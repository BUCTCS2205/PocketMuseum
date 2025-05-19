@Reusable
@Component
export default struct BackButton {
  @State
  isButtonPress: boolean = false;

  build() {
    Button({ type: ButtonType.Circle, buttonStyle: ButtonStyleMode.NORMAL }) {
      Flex({
        direction: FlexDirection.Row,
        justifyContent: FlexAlign.Center,
        alignItems: ItemAlign.Center
      }) {
          SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(30)
          .offset({
            x: -1,
            y: 0,
          })
        }
      }
    .height(44)
    .width(44)
    .scale({
      centerX: "50%",
      centerY: "50%",
      x: this.isButtonPress ? 0.90 : 1,
      y: this.isButtonPress ? 0.90 : 1,
    })
    .animation({
      duration: 200,
      curve: Curve.Ease
    })
    .onTouch((event: TouchEvent) => {
      if (event.type == TouchType.Down) {
        this.isButtonPress = true
      } else if (event.type == TouchType.Up) {
        this.isButtonPress = false
      }
    })
    .transition(
      TransitionEffect.opacity(0)
        .combine(TransitionEffect.scale({
          centerX: "50%",
          centerY: "50%",
          x: 0.5,
          y: 0.5
        }))
        .animation({
          duration: 200,
          curve: Curve.Ease,
          delay: 50
        })
    )
  }
}