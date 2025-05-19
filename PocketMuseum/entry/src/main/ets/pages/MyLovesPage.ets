import router from '@ohos.router';
import BackButton from '../components/BackButton';
import JsonUser from '../model/JsonUser';
import JsonArtifact from '../model/JsonArtifact';
import { Params } from './ArtifactPage';
import Result from '../utilities/Result';
import { getLovesByUserId } from '../services/LoveApi';
import { getArtifactById } from '../services/ArtifactApi';
import ArtifactItem from '../components/ArtifactItem';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct MyLovesPage {

  private user: JsonUser | null = router.getParams() as JsonUser ?? null;

  @State
  private lovedArtifacts: JsonArtifact[] = [];

  async tryGetLovedArtifacts(): Promise<Result> {
    if (!this.user) {
      return Result.fail(null, "用户为空");
    }

    try {
      this.lovedArtifacts = [];
      const loves = await getLovesByUserId(this.user.id);
      for (let i = 0; i < loves.length; i++) {
        const love = loves[i];
        const artifact = await getArtifactById(love.artifactId);
        this.lovedArtifacts.push(artifact);
      }
      return Result.success();
    } catch (err) {
      return Result.fail(null, "获取收藏信息失败");
    }
  }

  build() {
    Column() {
      Row() {
        BackButton()
          .onClick(() => {
            router.back();
          })

        Text("我的收藏")
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
            ForEach(this.lovedArtifacts, (item: JsonArtifact) => {
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
      const result = await this.tryGetLovedArtifacts();
      if (!result.success) {
        promptAction.showToast({
          message: result.message,
          duration: 2000
        });
      }
    })
  }
}
