
@Component
export default struct SettingItem {
  @Prop
  public title: string;

  @Prop
  public image: PixelMap | ResourceStr | DrawableDescriptor;

  build() {
    Row() {
      Row() {
        Image(this.image)
          .width(22)
          .height(22)

        Text(this.title)
          .fontSize(16)
          .fontFamily("SerifSemiBold")
          .margin({ left: 12 })
      }

      Image($r('app.media.right_grey'))
        .width(12)
        .height(24)
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .padding({ left: 8, right: 22 })
  }
}