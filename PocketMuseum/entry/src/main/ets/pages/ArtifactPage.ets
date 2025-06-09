import router from "@ohos.router";
import BackButton from "../components/BackButton";
import { common, Want } from "@kit.AbilityKit";
import JsonArtifact from "../model/JsonArtifact";
import JsonComment from "../model/JsonComment";
import { createComment, getCommentsByArtifactId } from "../services/CommentApi";
import promptAction from "@ohos.promptAction";
import JsonUser from "../model/JsonUser";
import dayjs from "dayjs";
import Result from "../utilities/Result";
import CommentItem from "../components/CommentItem";
import JsonLove from "../model/JsonLove";
import { createLove, deleteLove, getLovesByArtifactId } from "../services/LoveApi";
import { addHistoryRecord } from "../services/BrowseHistory";
import RefreshButton from "../components/RefreshButton";

export interface Params {
  artifact: JsonArtifact;
  user: JsonUser | null;
}

@Entry
@Component
struct ArtifactPage {

  openUrl(url: string): void {
    let context = getContext(this) as common.UIAbilityContext;
    let want: Want = {
      action: "ohos.want.action.viewData",
      bundleName: 'com.huawei.hmos.browser',
      abilityName: 'MainAbility',
      uri: url
    };
    context.startAbility(want);
  }

  private params: Params | null = router.getParams() as Params;

  private artifact: JsonArtifact = this.params?.artifact ?? {
    id: 0,
    title: "",
    artist: "",
    background: "",
    age: "",
    material: "",
    size: "",
    classify: "",
    description: "",
    url: "",
    link: ""
  };

  private user: JsonUser = this.params?.user ?? {
    id: 0,
    username: "",
    email: "",
    password: "",
    avatar: "",
    registrationTime: "",
    lastLogin: null,
    status: "正常",
  };

  @State
  private description: string = "";

  @State
  private comments: JsonComment[] = [];

  @State
  private commentLabel: string = "评论";

  @State
  private commentText: string = "";

  @State
  private isLoved: boolean = false;

  @State
  private lovesCount: number = 0;

  formatDescription(description: string): string {
    description = description.replace(/^[\r\n"']+|[\r\n"']+$/g, '');
    const full2 = '\u3000\u3000';
    if (!description.startsWith(full2)) {
      description = full2 + description;
    }
    return description;
  }

  async tryGetLoves(): Promise<Result> {
    try {
      const loves = await getLovesByArtifactId(this.artifact.id);
      let found = false;
      for (let i = 0; i < loves.length; i++) {
        const love = loves[i];
        if (love.userId == this.user.id) {
          this.isLoved = true;
          found = true;
          break;
        }
      }
      if (!found) {
        this.isLoved = false;
      }
      this.lovesCount = loves.length;
    } catch (err) {
      return Result.fail(null, "获取收藏信息失败");
    }
    return Result.success();
  }

  async tryChangeLove(): Promise<Result> {
    const now = dayjs(new Date()).format();
    if (this.isLoved) {
      try {
        const love: JsonLove = {
          userId: this.user.id,
          artifactId: this.artifact.id,
          loveTime: now
        };
        await deleteLove(love);
      } catch (err) {
        return Result.fail(null, "取消收藏失败");
      }
    }
    else {
      try {
        const love: JsonLove = {
          userId: this.user.id,
          artifactId: this.artifact.id,
          loveTime: now
        };
        await createLove(love);
      } catch (err) {
        return Result.fail(null, "收藏失败");
      }
    }
    return this.tryGetLoves();
  }

  async tryCreateComment(): Promise<Result> {
    const commentText = this.commentText.trim();
    if (commentText.length < 1) {
      return Result.fail(null, "评论不得为空");
    }
    if (commentText.length > 250) {
      return Result.fail(null, "评论不得长于250字符");
    }

    const comment: JsonComment = {
      id: 0,
      userId: this.user.id,
      artifactId: this.artifact.id,
      text: commentText,
      commentTime: dayjs(new Date()).format(),
      passed: true
    };
    try {
      const _ = await createComment(comment);
    }
    catch (err) {
      return Result.fail(null, "评论失败");
    }
    this.comments = await getCommentsByArtifactId(this.artifact.id);
    this.commentLabel = `评论(${this.comments.length})`
    return Result.success(null, "评论已发布");
  }

  build() {
    Column() {
      Row() {
        BackButton()
          .onClick(() => {
            router.back();
          })

        Text("文物详情")
          .fontSize(22)
          .fontFamily("SerifBold")
          .margin({ left: 10 })
      }
      .margin({ top: 10 })
      .padding({ bottom: 10 })
      .alignSelf(ItemAlign.Start)

      Scroll() {
        Column() {
          Text(this.artifact.title)
            .fontSize(28)
            .fontFamily("SerifBold")
            .textOverflow({ overflow: TextOverflow.Clip })
            .maxLines(10)
            .lineHeight(36)
            .alignSelf(ItemAlign.Start)

          //文物相关图片
          Stack() {
            Image(this.artifact.url)
              .width("100%")
              .objectFit(ImageFit.Cover)
              .borderRadius(15)
              .clip(true)
              .constraintSize({
                minWidth: "100%",
                maxWidth: "100%",
                minHeight: "30%",
                maxHeight: "70%"
              })

            Row() {
              Image(this.isLoved ? $r("app.media.love_fill") : $r("app.media.love"))
                .width(17)
                .height(17)
                .onClick(async () => {
                  const result = await this.tryChangeLove();
                  if (!result.success) {
                    promptAction.showToast({
                      message: result.message,
                      duration: 2000
                    });
                  }
                })

              Text(this.lovesCount.toString())
                .fontSize(16)
                .fontFamily("SerifSemiBold")
                .margin({ left: 5 })
            }
            .position({ left: 10, top: 10 })
            .backgroundColor(Color.White)
            .padding({ left: 8, right: 10, top: 4, bottom: 4 })
            .borderRadius(16)

            Button("源网页")
              .backgroundColor('#fdb93a')
              .fontColor(Color.Black)
              .fontFamily("SerifSemiBold")
              .borderRadius(12)
              .position({ right: 10, bottom: 10 })
              .alignSelf(ItemAlign.End)
              .onClick(() => {
                this.openUrl(this.artifact.link);
              })
          }
          .margin({ top: 10 })
          .width("100%")

          Row() {
            Column() {
              Text("作者：")
                .fontSize(15)
                .fontFamily("SerifSemiBold")
                .textAlign(TextAlign.Start)
                .alignSelf(ItemAlign.Start)
            }
            .alignSelf(ItemAlign.Start)
            .width("14%")

            Column() {
              Text(this.artifact.artist)
                .fontSize(15)
                .fontFamily("SerifRegular")
                .textAlign(TextAlign.Start)
                .alignSelf(ItemAlign.Start)
            }
            .alignSelf(ItemAlign.Start)
            .width("86%")
          }
          .margin({ top: 15 })
          .alignItems(VerticalAlign.Top)

          Row() {
            Column() {
              Text("背景：")
                .fontSize(15)
                .fontFamily("SerifSemiBold")
                .textAlign(TextAlign.Start)
                .alignSelf(ItemAlign.Start)
            }
            .alignSelf(ItemAlign.Start)
            .width("14%")

            Column() {
              Text(this.artifact.background)
                .fontSize(15)
                .fontFamily("SerifRegular")
                .textAlign(TextAlign.Start)
                .alignSelf(ItemAlign.Start)
            }
            .alignSelf(ItemAlign.Start)
            .width("86%")
          }
          .margin({ top: 1 })
          .alignItems(VerticalAlign.Top)

          Row() {
            Column() {
              Text("年代：")
                .fontSize(15)
                .fontFamily("SerifSemiBold")
                .textAlign(TextAlign.Start)
                .alignSelf(ItemAlign.Start)
            }
            .alignSelf(ItemAlign.Start)
            .width("14%")

            Column() {
              Text(this.artifact.age)
                .fontSize(15)
                .fontFamily("SerifRegular")
                .textAlign(TextAlign.Start)
                .alignSelf(ItemAlign.Start)
            }
            .alignSelf(ItemAlign.Start)
            .width("86%")
          }
          .margin({ top: 1 })
          .alignItems(VerticalAlign.Top)

          Row() {
            Column() {
              Text("分类：")
                .fontSize(15)
                .fontFamily("SerifSemiBold")
                .textAlign(TextAlign.Start)
                .alignSelf(ItemAlign.Start)
            }
            .alignSelf(ItemAlign.Start)
            .width("14%")

            Column() {
              Text(this.artifact.classify)
                .fontSize(15)
                .fontFamily("SerifRegular")
                .textAlign(TextAlign.Start)
                .alignSelf(ItemAlign.Start)
            }
            .alignSelf(ItemAlign.Start)
            .width("86%")
          }
          .margin({ top: 1 })
          .alignItems(VerticalAlign.Top)

          Row() {
            Column() {
              Text("材质：")
                .fontSize(15)
                .fontFamily("SerifSemiBold")
                .textAlign(TextAlign.Start)
                .alignSelf(ItemAlign.Start)
            }
            .alignSelf(ItemAlign.Start)
            .width("14%")

            Column() {
              Text(this.artifact.material)
                .fontSize(15)
                .fontFamily("SerifRegular")
                .textAlign(TextAlign.Start)
                .alignSelf(ItemAlign.Start)
            }
            .alignSelf(ItemAlign.Start)
            .width("86%")
          }
          .margin({ top: 1 })
          .alignItems(VerticalAlign.Top)

          Row() {
            Column() {
              Text("尺寸：")
                .fontSize(15)
                .fontFamily("SerifSemiBold")
                .textAlign(TextAlign.Start)
                .alignSelf(ItemAlign.Start)
            }
            .alignSelf(ItemAlign.Start)
            .width("14%")

            Column() {
              Text(this.artifact.size)
                .fontSize(15)
                .fontFamily("SerifRegular")
                .textAlign(TextAlign.Start)
                .alignSelf(ItemAlign.Start)
            }
            .alignSelf(ItemAlign.Start)
            .width("86%")
          }
          .margin({ top: 1 })
          .alignItems(VerticalAlign.Top)

          Text("详解")
            .fontSize(18)
            .fontFamily("SerifBold")
            .margin({ top: 8 })
            .alignSelf(ItemAlign.Start)

          Text(this.description)
            .fontSize(15)
            .fontFamily("SerifRegular")
            .textAlign(TextAlign.JUSTIFY)
            .margin({ top: 2 })

          Line()
            .width("100%")
            .height(1)
            .startPoint([0, 1])
            .endPoint([2000, 1])
            .stroke("#d0d0d0")
            .strokeWidth(1)
            .margin({ top: 12.5 })
            .alignSelf(ItemAlign.Center)

          Row() {
            Text(this.commentLabel)
              .fontSize(18)
              .fontFamily("SerifBold")
              .alignSelf(ItemAlign.Start)

            Blank()

            RefreshButton()
              .alignSelf(ItemAlign.End)
              .onClick(async () => {
                this.comments = await getCommentsByArtifactId(this.artifact.id);
                this.commentLabel = `评论(${this.comments.length})`;

                const result = await this.tryGetLoves();
                if (!result.success) {
                  promptAction.showToast({
                    message: result.message,
                    duration: 2000
                  });
                }
                else {
                  promptAction.showToast({
                    message: "刷新成功",
                    duration: 2000
                  });
                }
              })
          }
          .width("100%")
          .margin({ top: 12.5 })
          .alignItems(VerticalAlign.Center)
          .alignSelf(ItemAlign.Start)

          List({ space: 10 }) {
            ForEach(this.comments, (item: JsonComment) => {
              CommentItem({ comment: item })
            })
          }
          .margin({ top: 5 })
          .divider({
            strokeWidth: 1,
            color: "#dfdfdf",
          })

          if (this.comments.length == 0) {
            Text("暂无评论")
              .fontSize(14)
              .fontFamily("SerifRegular")
              .fontColor("#404040")
          }

          Row() {
            TextInput({
              placeholder: this.user.status == "正常" ? "善语结善缘，恶语伤人心" : "您已被禁言",
              text: $$this.commentText
            }).type(InputType.Normal)
              .placeholderColor($r('app.color.placeholder_color'))
              .width("75%")
              .height(40)
              .fontSize(15)
              .fontFamily("SerifRegular")
              .placeholderFont({ family: "SerifRegular" })
              .backgroundColor("#F1F3F5")
              .padding({ left: 20 })
              .alignSelf(ItemAlign.Start)
              .enabled(this.user.status == "正常")

            Blank()
              .width("5%")

            Button("发布")
              .width("20%")
              .height(40)
              .fontSize(15)
              .fontFamily("SerifBold")
              .alignSelf(ItemAlign.End)
              .enabled(this.user.status == "正常")
              .onClick(async () => {
                const result = await this.tryCreateComment();
                promptAction.showToast({
                  message: result.message,
                  duration: 2000
                });
                this.commentText = "";
              })
          }
          .alignItems(VerticalAlign.Center)
          .margin({ top: 15 })
        }
      }
      .width("100%")
      .flexGrow(1)
      .alignSelf(ItemAlign.Start)
      .align(Alignment.TopStart)
    }
    .width("100%")
    .height("100%")
    .alignSelf(ItemAlign.Start)
    .align(Alignment.TopStart)
    .padding({ left: "5%", right: "5%", top: 15, bottom: 65 })
    .onAppear(async () => {
      addHistoryRecord(this.user.id, this.artifact.id);

      this.description = this.formatDescription(this.artifact.description);
      this.comments = await getCommentsByArtifactId(this.artifact.id);
      this.commentLabel = `评论(${this.comments.length})`;

      const result = await this.tryGetLoves();
      if (!result.success) {
        promptAction.showToast({
          message: result.message,
          duration: 2000
        });
      }
    })
  }
}
