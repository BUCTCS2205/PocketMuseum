import JsonArtifact from "../model/JsonArtifact"

@Component
export default struct ArtifactItem {
  @Prop
  public artifact: JsonArtifact;

  @Prop
  public itemBorderColor: ResourceColor | EdgeColors | LocalizedEdgeColors = Color.Transparent;

  build() {
    Row() {
      Image(this.artifact.url)
        .width("22.5%")
        .height("80%")

      Blank()
        .width("5%")

      Column() {
        Text(this.artifact.title)
          .fontSize(16)
          .fontFamily("SerifSemiBold")
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(this.artifact.age)
          .fontSize(14)
          .fontFamily("SerifRegular")
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width("72.5%")
      .alignItems(HorizontalAlign.Start)
    }
    .padding({ left: 15, right: 10 })
    .alignItems(VerticalAlign.Center)
    .width("100%")
    .height(90)
    .backgroundColor(Color.White)
    .borderRadius(15)
    .borderColor(this.itemBorderColor)
    .borderWidth(1)
  }
}