import router from '@ohos.router';
import BackButton from '../components/BackButton';
import { updateUser } from '../services/UserApi';
import { PhotoClass } from '../utilities/PhotoClass';
import Result from '../utilities/Result';
import { base64ToPixelMap, loadDeviceImage, pixelMapToBase64 } from '../utilities/Utilities';
import promptAction from '@ohos.promptAction';
import JsonUser from '../model/JsonUser';

@Extend(Text)
function textStyle() {
  .fontSize(18)
  .fontFamily("SerifSemiBold")
  .margin({ top: 20 })
  .width("18%")
}

@Extend(TextInput)
function inputStyle() {
  .placeholderColor($r('app.color.placeholder_color'))
  .height(45)
  .fontSize(18)
  .fontFamily("SerifRegular")
  .placeholderFont({ family: "SerifRegular" })
  .backgroundColor("#F1F3F5")
  .width('82%')
  .padding({ left: 20 })
  .margin({ top: 20 })
}

@Entry
@Component
struct ProfilePage {

  private user: JsonUser | null = router.getParams() as JsonUser ?? null;

  @State
  private avatar: PixelMap | null = null;

  @State
  private avatarBase64: string | null = this.user?.avatar ?? null;

  @State
  private userName: string = this.user?.username ?? "";

  @State
  private email: string = this.user?.email ?? "";

  async tryModify(): Promise<Result> {
    if (this.user == null) {
      return Result.fail(null, "用户为空");
    }
    if (this.userName.length < 5) {
      return Result.fail(null, "用户名过短");
    }
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    if (!emailRegex.test(this.email)) {
      return Result.fail(null, "请输入有效的邮箱地址");
    }

    this.user.username = this.userName;
    this.user.email = this.email;
    this.user.avatar = this.avatarBase64;
    try {
      this.user = await updateUser(this.user);
      return Result.success(null, "保存成功");
    } catch (err) {
      return Result.error(null, err, "保存失败");
    }
  }

  build() {
    Column() {
      // 页面标题
      Row() {
        BackButton()
          .onClick(() => {
            router.back();
          })

        Text('编辑个人信息')
          .fontSize(22)
          .fontFamily("SerifBold")
          .margin({ left: 10 })
      }
      .margin({ top: 20 })
      .alignSelf(ItemAlign.Start)

      // 头像区域
      Column() {
        Stack() {
          Image(this.avatar ?? $r("app.media.account"))
            .width(75)
            .height(75)
            .borderRadius(38)
            .onAppear(async () => {
              if (this.avatarBase64 != null) {
                this.avatar = await base64ToPixelMap(this.avatarBase64);
              }
            })

          Circle()
            .width(80)
            .height(80)
            .fill(Color.Transparent)
            .borderRadius(40)
            .borderColor("#AFAFAF")
            .borderWidth(1.5)
        }
        .width(80)
        .height(80)
        .onClick(async () => {
          try {
            const picPath = await PhotoClass.photoAlbum(getContext());
            this.avatar = await loadDeviceImage(picPath, { width: 512, height: 512 });
            this.avatarBase64 = await pixelMapToBase64(this.avatar);
          } catch (error) {
            console.error("访问相册过程中发生错误: ", error);
          }
        })

        Text('点击更换头像')
          .fontSize(14)
          .fontFamily("SerifSemiBold")
          .margin({ top: 8 })
      }
      .margin({ top: 15 })
      .alignItems(HorizontalAlign.Center)

      // 昵称输入框
      Column() {
        Row() {
          Text("昵称：")
            .textStyle()

          TextInput({
            text: this.userName,
            placeholder: "昵称"
          })
            .inputStyle()
            .type(InputType.Normal)
            .onChange((value: string) => {
              this.userName = value;
            })
        }
        .alignSelf(ItemAlign.Center)

        Row() {
          Text("邮箱：")
            .textStyle()

          TextInput({
            text: this.email,
            placeholder: "邮箱"
          })
            .inputStyle()
            .type(InputType.Normal)
            .onChange((value: string) => {
              this.email = value;
            })
        }
        .alignSelf(ItemAlign.Center)
      }
      .width('100%') // 设置宽度为100%
      .alignItems(HorizontalAlign.Center) // 居中对齐

      // 保存按钮
      Button("确认", { type: ButtonType.Capsule })
        .width("100%")
        .height(40)
        .margin({ top: 35 })
        .fontSize(18)
        .fontFamily("SerifBold")
        .backgroundColor(Color.Blue)
        .fontColor(Color.White)
        .onClick(async () => {
          let result = await this.tryModify();
          if (result.success) {
            router.clear();
            router.pushUrl({
              url: "pages/IndexPage",
              params: this.user
            })
          }
          promptAction.showToast({
            message: result.message,
            duration: 2000
          })
        })

      Button('修改密码', { type: ButtonType.Capsule })
        .width("100%")
        .height(40)
        .margin({ top: 20 })
        .fontSize(18)
        .fontFamily("SerifBold")
        .backgroundColor("#EFEFEF")
        .fontColor(Color.Black)
        .onClick(() => {
          router.pushUrl({
            url: "pages/ModifyPasswordPage",
            params: this.user
          });
        })
    }
    .width("100%")
    .height("100%")
    .padding({ left: "4%", right: "4%" })
    .alignItems(HorizontalAlign.Center)
  }
}
