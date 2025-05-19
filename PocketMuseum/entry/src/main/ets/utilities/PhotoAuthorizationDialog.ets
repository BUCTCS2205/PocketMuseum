import { common, Want } from "@kit.AbilityKit"

@CustomDialog
export struct CustomDialogExampleTwo {
  controllerTwo?: CustomDialogController

  build() {
    Column() {
      Text('应用相机权限未开启，是否前往开启')
        .fontSize(20)
        .margin({ top: 45, bottom: 45 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .width('45%')
          .backgroundColor('#f4f4f4')
          .fontColor(Color.Black)
          .onClick(() => {
            this.controllerTwo?.close()
          })

        Button('前往')
          .width('45%')
          .backgroundColor('#ff313b')
          .fontColor(Color.White)
          .onClick(() => {
            let context = getContext(this) as common.UIAbilityContext;
            let want: Want = {
              bundleName: 'com.huawei.hmos.settings', //设置应用bundleName
              abilityName: 'com.huawei.hmos.settings.MainAbility', //设置应用abilityName
              uri: "application_info_entry", //通知管理页面
              parameters: {
                pushParams: context.abilityInfo.bundleName
              }
            }
            context.startAbility(want)
            this.controllerTwo?.close()
          })
      }
      .margin({ bottom: 20 })
    }
  }
}