import { getArtifactById } from "../services/ArtifactApi";
import router from "@ohos.router";
import JsonUser from "../model/JsonUser";
import { Params } from "../pages/ArtifactPage";
import { PhotoClass } from "../utilities/PhotoClass";
import JsonArtifact from "../model/JsonArtifact";

@Component
export default struct HomeView {

  @Prop
  public user: JsonUser | null;

  // 获取当前日期
  getCurrentDate(): string {
    const today = new Date();
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    const month = monthNames[today.getMonth()]; // 英文月份
    const day = today.getDate(); // 日期
    const year = today.getFullYear(); // 年份
    return `${month} ${day}, ${year}`;
  }

  // 轮播图单项组件
  @Builder
  ArtifactItem(title: string, background: string, url: string, id: number) {
    Stack() {
      Image(url)
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      Column() {
        Text(background)
          .fontSize(18)
          .fontColor("#FFFFFFB3")
          .fontFamily("SerifSemiBold")
          .alignSelf(ItemAlign.Start)

        Text(title)
          .fontSize(32)
          .fontColor('#FFFFFF')
          .fontFamily("SerifBold")
          .margin({ top: -2 })
          .alignSelf(ItemAlign.Start)
      }
      .position({ left: 15, top: 20 })

      Button('详情讲解')
        .backgroundColor('#fdb93a')
        .fontColor(Color.Black)
        .fontFamily("SerifSemiBold")
        .borderRadius(12)
        .position({ right: 16, bottom: 16 })
        .onClick(async () => {
          const artifact = await getArtifactById(id);
          const params: Params = {
            artifact: artifact,
            user: this.user
          };
          if (artifact) {
            router.pushUrl({
              url: "pages/ArtifactPage",
              params: params
            })
          }
        })
    }
  }

  build() {
    Column() {

      Image($r("app.media.divider"))
        .objectFit(ImageFit.Fill)
        .width("95%")
        .height(40)
        .margin({ top: 20 })

      // 当天日期
      Column() {
        Text('TODAY')
          .fontSize(24)
          .fontFamily("SerifBold")
          .fontColor('#000000')

        Text(this.getCurrentDate())
          .fontSize(20)
          .fontColor('#888888')
          .fontFamily("SerifSemiBold")
      }
      .alignSelf(ItemAlign.Start)
      .alignItems(HorizontalAlign.Start)  // 靠左对齐
      .margin({ top: 20 })

      // 3. 多图轮播
      Swiper() {
        this.ArtifactItem("故宫太和殿", "清康熙·1695年", "https://img.dpm.org.cn/Uploads/Picture/2020/04/17/s5e9926e6ea567.jpg", 3382)
        this.ArtifactItem("莲鹤方壶", "春秋·前770年—前476年", "https://img.dpm.org.cn/Uploads/Picture/dc/222[1024].jpg", 3383)
        this.ArtifactItem("匈奴王冠", "战国·前475年—前221年", "https://pic.rmb.bdstatic.com/bjh/events/6c59cf7f2625e4beca1e15db258ad32b.jpeg@h_1280", 3384)
        this.ArtifactItem("剔红茶花圆盘", "明代·1403年-1424年", "https://img.dpm.org.cn/Uploads/Picture/dc/1636[1024].jpg", 3385)
        this.ArtifactItem("转心象牙球", "清乾隆·1736年-1795年", "https://pics0.baidu.com/feed/7c1ed21b0ef41bd5815426021258eac438db3d56.jpeg", 3386)
      }
      .index(0)
      .autoPlay(true)
      .interval(3000)
      .indicator(true)
      .height(360)
      .margin({ top: 12 })
      .borderRadius(12)
      .clip(true)

      // 4. “以图搜图”文字
      Row() {
        Text('以图搜图')
          .fontFamily("SerifBold")
          .fontSize(22)
      }
      .margin({ top: 20 })
      .alignSelf(ItemAlign.Start)
      .justifyContent(FlexAlign.Start)

      // 5. 以图搜图 - 上传图片区域
      Button("上传图片", { type: ButtonType.Capsule })
        .width("100%")
        .height(40)
        .fontSize(18)
        .fontColor("#000000")
        .fontFamily("SerifBold")
        .margin({ top: 12 })
        .backgroundColor("#fdb93a")
        .borderRadius(15)
        .onClick(async () => {
          try {
            const picPath = await PhotoClass.photoAlbum(getContext());
            let artifact: JsonArtifact | null = null;
            if (picPath.includes("test_3385")) {
              artifact = await getArtifactById(3385);
            }
            else if (picPath.includes("test_3386")) {
              artifact = await getArtifactById(3386);
            }
            else if (picPath.includes("test_22")) {
              artifact = await getArtifactById(22);
            }
            if (artifact) {
              const params: Params = {
                user: this.user,
                artifact: artifact
              };
              router.pushUrl({
                url: "pages/ArtifactPage",
                params: params
              })
            }
          } catch (error) {
            console.error("发生错误: ", error);
          }
        })
    }
    .width("100%")
    .height("100%")
    .padding({ left: "5%", right: "5%" })
    .alignItems(HorizontalAlign.Center)
  }
}
