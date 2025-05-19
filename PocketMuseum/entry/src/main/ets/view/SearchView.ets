import router from "@ohos.router";
import Result from "../utilities/Result"
import { searchArtifacts } from "../services/ArtifactApi";
import JsonArtifact from "../model/JsonArtifact";
import promptAction from "@ohos.promptAction";
import JsonUser from "../model/JsonUser";
import { Params } from "../pages/ArtifactPage";
import ArtifactItem from "../components/ArtifactItem";

@Preview
@Component
export default struct SearchView {

  @Prop
  public user: JsonUser | null;

  @State
  private queriedItems: JsonArtifact[] = [];

  @State
  private query: string = "";

  async trySearch() : Promise<Result> {
    if (this.query == "") {
      this.queriedItems = [];
      return Result.success();
    }

    try {
      const result = await searchArtifacts(this.query);
      this.queriedItems = result;
    }
    catch (err) {
      return Result.error(null, err, "搜索失败");
    }
    return Result.success();
  }

  build() {
    Column() {
      Text("探索")
        .fontSize(28)
        .fontFamily("SerifBold")
        .margin({ left: 5, top: 20 })
        .alignSelf(ItemAlign.Start)

      Search({ placeholder: '搜索文物…' })
        .placeholderColor($r('app.color.placeholder_color'))
        .height(45)
        .textFont({
          size: 18,
          family: "SerifRegular"
        })
        .searchButton("搜索")
        .placeholderFont({ family: "SerifRegular" })
        .backgroundColor(Color.White)
        .margin({ top: 15 })
        .borderColor("#D0D0D0")
        .borderWidth(1)
        .onSubmit(async (value: string) => {
          this.query = value;
          const result = await this.trySearch();
          if (!result.success) {
            promptAction.showToast({
              message: result.message,
              duration: 2000
            });
          }
        })

      Stack() {
        Image($r("app.media.back"))
          .width("25%")
          .objectFit(ImageFit.Cover)
          .opacity(0.4)
          .alignSelf(ItemAlign.Center)
          .align(Alignment.Center)

        Scroll() {
          List({ space: 10 }) {
            ForEach(this.queriedItems, (item: JsonArtifact) => {
              ArtifactItem({ artifact: item })
                .onClick(() => {
                  const params: Params = {
                    artifact: item,
                    user: this.user
                  };
                  router.pushUrl({
                    url: "pages/ArtifactPage",
                    params: params
                  });
                })
            })
          }
        }
        .margin({ top: 10 })
        .position({ x: 0, y: 0 })
      }
      .margin({ top: 5 })
      .flexGrow(1)
    }
    .width("100%")
    .height("100%")
    .padding({ left: "4%", right: "4%", bottom: 30 })
    .alignItems(HorizontalAlign.Center)
  }
}