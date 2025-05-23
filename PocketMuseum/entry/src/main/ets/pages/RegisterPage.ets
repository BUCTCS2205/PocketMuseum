import router from '@ohos.router';
import promptAction from '@ohos.promptAction'
import { createUser } from '../services/UserApi'
import Result from '../utilities/Result'
import JsonUser from '../model/JsonUser';
import dayjs from 'dayjs';

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
struct RegisterPage {

  @State
  private name: string = "";

  @State
  private email: string = "";

  @State
  private password: string = "";

  @State
  private confirm: string = "";

  private user: JsonUser | null = null;

  async tryRegister() : Promise<Result> {
    if (this.name.length < 5) {
      return Result.fail(null, "用户名过短");
    }
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    if (!emailRegex.test(this.email)) {
      return Result.fail(null, "请输入有效的邮箱地址");
    }
    if (this.password.length < 8 || this.password.length > 16) {
      return Result.fail(null, "密码须在8~16位之间");
    }
    if (this.confirm != this.password) {
      return Result.fail(null, "密码与确认密码不一致")
    }
    const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z0-9_]{8,16}$/;
    if (!passwordRegex.test(this.password)) {
      return Result.fail(null, "密码必须包含数字、字母和符号中的至少两种");
    }

    try {
      const now = dayjs(new Date()).format();
      this.user = await createUser({
        id: 0,
        username: this.name,
        email: this.email,
        password: this.password,
        avatar: null,
        registrationTime: now,
        lastLogin: now
      });
      return Result.success(null, "注册成功");
    }
    catch (err) {
      return Result.error(null, err, "注册失败");
    }
  }

  build() {
    Column() {
      // 页面标题
      Text("注册账号")
        .fontSize(26)
        .fontFamily("SerifBold")
        .margin({ top: 120 })

      // 提示语
      Text("填写信息以创建新账号")
        .margin({ top: 10 })
        .fontColor("#606060")
        .textAlign(TextAlign.Center)
        .fontSize(14)
        .fontFamily("SerifRegular")

      // 输入框：账号
      TextInput({ placeholder: "用户名" })
        .inputStyle()
        .type(InputType.Normal)
        .onChange((value: string) => {
          this.name = value
        })

      // 输入框：邮箱
      TextInput({ placeholder: "邮箱" })
        .inputStyle()
        .type(InputType.Normal)
        .onChange((value: string) => {
          this.email = value
        })

      // 输入框：密码
      TextInput({ placeholder: "请输入密码" })
        .inputStyle()
        .type(InputType.Password)
        .onChange((value: string) => {
          this.password = value
        })

      // 输入框：确认密码
      TextInput({ placeholder: "请确认密码" })
        .inputStyle()
        .type(InputType.Password)
        .onChange((value: string) => {
          this.confirm = value
        })

      // 注册按钮
      Button("注册")
        .width("100%")
        .height(40)
        .margin({ top: 40 })
        .fontSize(18)
        .fontFamily("SerifBold")
        .onClick(async () => {
          const result = await this.tryRegister();
          if (result.success) {
            router.replaceUrl({
              url: "pages/IndexPage",
              params: this.user
            });
          }
          promptAction.showToast({
            message: result.message,
            duration: 2000
          });
        })

      // 已有账号提示
      Text("已有账号？点此登录")
        .margin({ top: 10 })
        .textAlign(TextAlign.Center)
        .fontSize(14)
        .fontFamily("SerifSemiBold")
        .onClick(() => {
          router.back();
        })
    }
    .width("100%")
    .height("100%")
    .padding({ left: "4%", right: "4%", top: "15%" })
    .alignItems(HorizontalAlign.Center)
  }
}
