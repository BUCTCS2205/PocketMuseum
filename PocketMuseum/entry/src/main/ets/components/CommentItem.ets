import JsonComment from "../model/JsonComment";
import JsonUser from "../model/JsonUser";
import { getUserById } from "../services/UserApi";
import { base64ToPixelMap } from "../utilities/Utilities";
import promptAction from "@ohos.promptAction";
import Result from "../utilities/Result";
import dayjs from "dayjs";

@Component
export default struct CommentItem {
  @Prop
  public comment: JsonComment;

  @State
  private user: JsonUser | null = null;

  @State
  private avatar: PixelMap | null = null;

  @State
  private commentTime: string = "";

  async tryGetInfo(): Promise<Result> {
    if (this.comment == null) {
      return Result.fail(null, "评论为空");
    }
    this.user = await getUserById(this.comment?.userId)
    if (this.user == null) {
      return Result.fail(null, "用户不存在");
    }
    if (this.user?.avatar) {
      this.avatar = await base64ToPixelMap(this.user.avatar);
    }
    this.commentTime = dayjs(this.comment.commentTime).format("YYYY-MM-DD HH:mm:ss");
    return Result.success();
  }

  build() {
    Column() {
      Row() {
        Stack() {
          Image(this.avatar ?? $r("app.media.account"))
            .width(36)
            .height(36)
            .borderRadius(18)

          Circle()
            .width("100%")
            .height("100%")
            .fill(Color.Transparent)
        }
        .width(37)
        .height(37)

        Column() {
          Text(this.user?.username)
            .fontSize(16)
            .fontFamily("SerifSemiBold")

          Text(this.commentTime)
            .fontColor("#606060")
            .fontSize(13)
            .fontFamily("SerifRegular")
        }
        .margin({ left: 10 })
        .alignItems(HorizontalAlign.Start)
      }

      Text(this.comment.text)
        .width("100%")
        .margin({ top: 7, left: 3, right: 3 })
        .fontSize(15)
        .fontFamily("SerifRegular")
    }
    .padding({ top: 3, bottom: 3 })
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .onAppear(async () => {
      const result = await this.tryGetInfo();
      if (!result.success) {
        promptAction.showToast({
          message: result.message,
          duration: 2000
        });
      }
    })
  }
}