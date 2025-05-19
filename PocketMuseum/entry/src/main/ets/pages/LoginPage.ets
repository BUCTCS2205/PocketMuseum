import router from '@ohos.router';
import promptAction from '@ohos.promptAction'
import { getUserByNameOrEmail, updateUser } from '../services/UserApi'
import Result from '../utilities/Result'
import dayjs from 'dayjs';
import JsonUser from '../model/JsonUser';

@Extend(TextInput)
function inputStyle() {
  .placeholderColor($r('app.color.placeholder_color'))
  .height(45)
  .fontSize(18)
  .fontFamily("SerifRegular")
  .placeholderFont({ family: "SerifRegular" })
  .backgroundColor("#F1F3F5")
  .padding({ left: 20 })
  .margin({ top: 20 })
}

@Entry
@Component
struct LoginPage {

  @State
  private nameOrEmail: string = "";

  @State
  private password: string = "";

  private user: JsonUser | null = null;

  async tryLogin() : Promise<Result> {
    if (this.nameOrEmail.length < 1) {
      return Result.fail(null, "用户名或邮箱不得为空");
    }
    if (this.password.length < 1) {
      return Result.fail(null, "密码不得为空");
    }

    try {
      let result = await getUserByNameOrEmail(this.nameOrEmail);
      if (this.password != result.password) {
        return Result.fail(null, "用户名或密码错误");
      }
      result.lastLogin = dayjs(new Date()).format();
      result = await updateUser(result);
      this.user = result;
      return result ? Result.success(null, "登录成功") : Result.fail(null, "登录失败");
    }
    catch (err) {
      return Result.error(null, err, "登录失败");
    }
  }

  build() {
    Column() {
      Image($r("app.media.icon"))
        .width(80)
        .height(80)
        .align(Alignment.Center)
        .backgroundImageSize(ImageSize.Auto)

      Text("用户登录")
        .margin({ top: 10 })
        .textAlign(TextAlign.Center)
        .fontSize(26)
        .fontFamily("SerifBold")

      TextInput({ placeholder: "用户名/邮箱" })
        .type(InputType.Normal)
        .inputStyle()
        .margin({ top: 50 })
        .onChange((value: string) => {
          this.nameOrEmail = value;
        })

      TextInput({ placeholder: "密码" })
        .type(InputType.Password)
        .inputStyle()
        .onChange((value: string) => {
          this.password = value;
        })

      Button("登录")
        .width("100%")
        .height(40)
        .margin({ top: 35 })
        .fontSize(18)
        .fontFamily("SerifBold")
        .onClick(async () => {
          const result = await this.tryLogin();
          if (result.success) {
            router.replaceUrl({
              url: "pages/IndexPage",
              params: this.user
            })
          }
          promptAction.showToast({
            message: result.message,
            duration: 2000
          })
        })

      Text("注册账号")
        .margin({ top: 10 })
        .textAlign(TextAlign.Center)
        .fontSize(14)
        .fontFamily("SerifSemiBold")
        .onClick(() => {
          router.pushUrl({ url: 'pages/RegisterPage' })
        })
    }
    .width("100%")
    .height("100%")
    .padding({ left: "5%", right: "5%", top: "40%" })
    .alignItems(HorizontalAlign.Center)
  }
}
