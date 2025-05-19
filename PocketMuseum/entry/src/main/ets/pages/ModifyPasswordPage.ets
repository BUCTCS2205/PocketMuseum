import router from '@ohos.router';
import BackButton from '../components/BackButton';
import Result from '../utilities/Result';
import { updateUser } from '../services/UserApi';
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
  .type(InputType.Password)
  .backgroundColor("#F1F3F5")
  .width('82%')
  .padding({ left: 20 })
  .margin({ top: 20 })
}

@Entry
@Component
struct ModifyPasswordPage {
  // 从上一页接收参数
  private user: JsonUser | null = router.getParams() as JsonUser ?? null;

  @State
  private password: string = "";

  @State
  private confirm: string = "";

  async tryModify(): Promise<Result> {
    if (this.user == null) {
      return Result.fail(null, "用户为空");
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

    this.user.password = this.password;
    try {
      this.user = await updateUser(this.user);
      return Result.success(null, "保存成功");
    } catch (err) {
      return Result.error(null, err, "保存失败");
    }
  }

  build() {
    Column() {
      Row() {
        BackButton()
          .onClick(() => {
            router.back();
          })

        Text("修改密码")
          .fontSize(22)
          .fontFamily("SerifBold")
          .margin({ left: 10 })
      }
      .margin({ top: 20 })
      .alignSelf(ItemAlign.Start)

      // 昵称输入框
      Column() {
        Row() {
          Text("密码：")
            .textStyle()

          TextInput({
            text: this.password,
            placeholder: "密码"
          })
            .inputStyle()
            .onChange((value: string) => {
              this.password = value;
            })
        }
        .alignSelf(ItemAlign.Center)

        Row() {
          Text("确认：")
            .textStyle()

          TextInput({
            text: this.confirm,
            placeholder: "确认密码"
          })
            .inputStyle()
            .onChange((value: string) => {
              this.confirm = value;
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
            router.back();
          }
          promptAction.showToast({
            message: result.message,
            duration: 2000
          })
        })

      Button("返回", { type: ButtonType.Capsule })
        .width("100%")
        .height(40)
        .margin({ top: 20 })
        .fontSize(18)
        .fontFamily("SerifBold")
        .backgroundColor("#EFEFEF")
        .fontColor(Color.Black)
        .onClick(() => {
          router.back();
        })
    }
    .width("100%")
    .height("100%")
    .padding({ left: "4%", right: "4%" })
    .alignItems(HorizontalAlign.Center)
  }
}
