import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import JsonUser from '../model/JsonUser';
import { base64ToPixelMap } from '../utilities/Utilities';
import SettingItem from '../components/SettingItem';

@Preview
@Component
export default struct MineView {

  @Prop
  public user: JsonUser | null;

  @State
  private avatar: PixelMap | null = null;

  build() {
    Column() {
      // 顶部标题
      Text('我的')
        .fontFamily("SerifBold")
        .fontSize(28)
        .margin({ left: 5, top: 20 })
        .align(Alignment.Start)
        .alignSelf(ItemAlign.Start)

      // 个人信息
      Row() {
        Stack() {
          Image(this.avatar ?? $r("app.media.account"))
            .width(47)
            .height(47)
            .borderRadius(24)

          Circle()
            .width("100%")
            .height("100%")
            .fill(Color.Transparent)
        }
        .width(48)
        .height(48)
        .onAppear(async () => {
          if (this.user?.avatar) {
            this.avatar = await base64ToPixelMap(this.user?.avatar);
          }
        })

        Column() {
          Text(this.user?.username)
            .fontSize(20)
            .fontFamily("SerifSemiBold")
            .fontWeight(FontWeight.Medium)

          Text(this.user?.email)
            .fontSize(14)
            .fontFamily("SerifRegular")
        }
        .margin({ left: 15 })
        .alignItems(HorizontalAlign.Start)

        Blank()

        Image($r('app.media.right_grey'))
          .width(12)
          .height(24)
          .align(Alignment.End)
      }
      .margin({ top: 15 })
      .padding({ left: 15, right: 22, top: 3, bottom: 3 })
      .alignItems(VerticalAlign.Center)
      .width('100%')
      .height(96)
      .backgroundColor(Color.White)
      .borderRadius(16)
      .onClick(() => {
        router.pushUrl({
          url: "pages/ProfilePage",
          params: this.user
        });
      })

      // 功能列表
      List() {
        ListItem() {
          SettingItem({
            title: "我的收藏",
            image: $r("app.media.love_fill")
          }).onClick(() => {
            router.pushUrl({
              url: "pages/MyLovesPage",
              params: this.user
            });
          })
        }
        .height(45)
        .margin({ left: 7 })

        ListItem() {
          SettingItem({
            title: "我的足迹",
            image: $r("app.media.time")
          }).onClick(() => {
            router.pushUrl({
              url: "pages/HistoryPage",
              params: this.user
            });
          })
        }
        .height(45)
        .margin({ left: 7 })
      }
      .backgroundColor(Color.White)
      .width('100%')
      .height('auto')
      .divider({
        strokeWidth: 1,
        color: "#dfdfdf",
      })
      .borderRadius(16)
      .margin({ top: 20 })

      // 添加图片网格（2行2列）
      Column({ space: 10 }) {
        Row({ space: 10 }) {
          Image($r('app.media.pic1'))
            .width('48%')
            .aspectRatio(1)
            .borderRadius(10)
          Image($r('app.media.pic2'))
            .width('48%')
            .aspectRatio(1)
            .borderRadius(10)
        }.width('100%')

        Row({ space: 10 }) {
          Image($r('app.media.pic3'))
            .width('48%')
            .aspectRatio(1)
            .borderRadius(10)
          Image($r('app.media.pic4'))
            .width('48%')
            .aspectRatio(1)
            .borderRadius(10)
        }.width('100%')
      }
      .width('100%')
      .padding(12)
      .backgroundColor(Color.White)
      .borderRadius(13)
      .margin({ top: 20 })

      // 退出登录按钮
      Button('退出登录', { type: ButtonType.Capsule })
        .width("100%")
        .height(40)
        .fontSize(18)
        .fontColor("#FA2A2D")
        .fontFamily("SerifBold")
        .backgroundColor("#E5E8EA")
        .margin({ top: 20 })
        .onClick(() => {
          promptAction.showToast({
            message: '退出登录',
            duration: 2000
          })
          router.replaceUrl({ url: 'pages/LoginPage' })
        })
    }
    .width("100%")
    .height("100%")
    .padding({ left: "4%", right: "4%", bottom: 30 })
    .alignItems(HorizontalAlign.Center)
  }
}
