import { photoAccessHelper } from "@kit.MediaLibraryKit";
import { abilityAccessCtrl, bundleManager, common, Permissions, Want } from '@kit.AbilityKit';
import { BusinessError } from "@kit.BasicServicesKit";
import { promptAction } from "@kit.ArkUI";

class Permission {
  private atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  private confirmConfig: promptAction.ShowDialogOptions = {
    title: "温馨提示",
    message: "未授权访问媒体资源无法打开相册，是否前往设置进行授权？",
    buttons: [
      { text: '离开', color: '40vp' },
      { text: '去授权', color: '#000' }
    ]
  }

  // 检查是否授权
  async checkAccess(permissions: Permissions) {
    let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION |
    bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_METADATA;
    const ApplicationInfo = bundleManager.getBundleInfoForSelfSync(bundleFlags)
    let tokenID: number = ApplicationInfo.appInfo.accessTokenId
    const data = await this.atManager.checkAccessToken(tokenID, permissions)
    if (data === 0) {
      return true

    } else {
      return false
    }
  }

  // 申请授权
  async reqPermissionsFromUser(permissions: Array<Permissions>, context: common.UIAbilityContext) {
    // 选中图片信息
    const data = await this.atManager.requestPermissionsFromUser(context, permissions)

    let grantStatus: Array<number> = data.authResults;
    if (grantStatus[0] === 0) {
      // 用户授权，可以继续访问目标操作
      const str = await this.updateAvatar()
      return str
    } else {
      // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
      promptAction.showDialog(this.confirmConfig).then((confirm) => {
        if (confirm.index === 1) {
          this.openPermissionSetting(permissions)
        }
      })
      return ''
    }
  }

  // 打开权限设置
  async openPermissionSetting(permissions: Array<Permissions>) {
    let context: Context = getContext(this) as common.UIAbilityContext;
    this.atManager.requestPermissionOnSetting(context, permissions)
      .then((data: Array<abilityAccessCtrl.GrantStatus>) => {
        if (data[0] === 0) {
          promptAction.showToast({ message: '授权成功' })
        } else {
          promptAction.showToast({ message: '授权失败,请重新授权' })

        }
      })
      .catch((err: BusinessError) => {
        console.log('openPermissionSettingErr', JSON.stringify(err))
      });
  }

  // 打开相册
  async updateAvatar() {
    // 1. 选择相册照片
    // 选择照片配置
    const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions()
    photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE
    photoSelectOptions.maxSelectNumber = 1
    // 选择照片对象
    const photoPicker = new photoAccessHelper.PhotoViewPicker()
    const photoResult = await photoPicker.select(photoSelectOptions)
    const uri = photoResult.photoUris[0]
    return uri
  }
}

export const permission = new Permission()