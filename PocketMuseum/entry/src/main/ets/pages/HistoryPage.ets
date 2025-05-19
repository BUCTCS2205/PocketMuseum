import router from '@ohos.router';
import BackButton from '../components/BackButton';
import JsonUser from '../model/JsonUser';
import JsonArtifact from '../model/JsonArtifact';
import { Params } from './ArtifactPage';
import Result from '../utilities/Result';
import { getArtifactById } from '../services/ArtifactApi';
import ArtifactItem from '../components/ArtifactItem';
import promptAction from '@ohos.promptAction';
import { getArtifactIdsByUserId } from '../services/BrowseHistory';

@Entry
@Component
struct HistoryPage {

  private user: JsonUser | null = router.getParams() as JsonUser ?? null;

  @State
  private browsedArtifacts: JsonArtifact[] = [];

  async tryGetBroswedArtifacts(): Promise<Result> {
    if (!this.user) {
      return Result.fail(null, "用户为空");
    }

    try {
      this.browsedArtifacts = [];
      const ids = getArtifactIdsByUserId(this.user.id);
      for (let i = ids.length - 1; i >= 0; i--) {
        const id = ids[i];
        const artifact = await getArtifactById(id);
        this.browsedArtifacts.push(artifact);
      }
      return Result.success();
    } catch (err) {
      return Result.fail(null, "获取历史记录失败");
    }
  }

  build() {
    Column() {
      Row() {
        BackButton()
          .onClick(() => {
            router.back();
          })

        Text("我的足迹")
          .fontSize(22)
          .fontFamily("SerifBold")
          .margin({ left: 10 })
      }
      .margin({ top: 20 })
      .alignSelf(ItemAlign.Start)

      Stack() {
        Image($r("app.media.back"))
          .width("25%")
          .objectFit(ImageFit.Cover)
          .opacity(0.4)
          .alignSelf(ItemAlign.Center)
          .align(Alignment.Center)

        Scroll() {
          List({ space: 7.5 }) {
            ForEach(this.browsedArtifacts, (item: JsonArtifact) => {
              ArtifactItem({
                artifact: item,
                itemBorderColor: "#CFCFCF"
              }).onClick(() => {
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
    .onAppear(async () => {
      const result = await this.tryGetBroswedArtifacts();
      if (!result.success) {
        promptAction.showToast({
          message: result.message,
          duration: 2000
        });
      }
    })
  }
}
