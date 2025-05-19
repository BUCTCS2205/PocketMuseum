import { camera, cameraPicker } from "@kit.CameraKit"
import { abilityAccessCtrl, common, Permissions } from "@kit.AbilityKit"
import { BusinessError } from "@kit.BasicServicesKit"
import { CustomDialogExampleTwo } from "./PhotoAuthorizationDialog";
import { permission } from "./Permission";

export class PhotoClass {
  private static dialogControllerTwo: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogExampleTwo(),
    onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
      console.info("reason=" + JSON.stringify(dismissDialogAction.reason));
      console.log("dialog onWillDismiss");
      if (dismissDialogAction.reason === DismissReason.PRESS_BACK ||
        dismissDialogAction.reason === DismissReason.TOUCH_OUTSIDE) {
        dismissDialogAction.dismiss();
      }
    },
    offset: { dx: 0, dy: -25 }
  });
  private static PermissionsData: Permissions[] = ['ohos.permission.READ_MEDIA'];
  private static context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  public static async startCameraPicker(context: Context): Promise<string | undefined> {
    try {
      const pickerProfile: cameraPicker.PickerProfile = {
        cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK
      };
      const pickerResult: cameraPicker.PickerResult = await cameraPicker.pick(context,
        [cameraPicker.PickerMediaType.PHOTO, cameraPicker.PickerMediaType.VIDEO],
        pickerProfile
      );
      console.log("The picker result is: " + JSON.stringify(pickerResult));
      if (pickerResult.resultCode === 0) {
        const takePicture = pickerResult.resultUri;
        context.eventHub.emit("updateImage", pickerResult.resultUri);
        return takePicture
      }
    } catch (error) {
      const err = error as BusinessError;
      console.error(`The pick call failed. Error code: ${err.code}`);
      return undefined
    }
    return undefined
  }

  public static async photoAlbum(context: Context): Promise<string> {
    let url: string = '';

    const isAccess = await permission.checkAccess(PhotoClass.PermissionsData[0]);
    if (isAccess) {
      url = await permission.updateAvatar();
    } else {
      url = await permission.reqPermissionsFromUser(PhotoClass.PermissionsData, PhotoClass.context);
    }

    return url;
  }

  public static async reqPermissionsFromUser(): Promise<number[]> {
    const context = getContext() as common.UIAbilityContext;
    const atManager = abilityAccessCtrl.createAtManager();
    const grantStatus = await atManager.requestPermissionsFromUser(context, ['ohos.permission.CAMERA']);
    return grantStatus.authResults;
  }

  public static async requestCameraPermission(): Promise<string | undefined> {
    const grantStatus = await PhotoClass.reqPermissionsFromUser();
    for (const status of grantStatus) {
      if (status === 0) {
        return await PhotoClass.startCameraPicker(PhotoClass.context);
      } else if (status === -1 && PhotoClass.dialogControllerTwo) {
        await PhotoClass.dialogControllerTwo.open();
      }
    }
    return undefined
  }
}