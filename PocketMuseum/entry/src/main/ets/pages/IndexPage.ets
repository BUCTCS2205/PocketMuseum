import router from '@ohos.router';
import MineView from '../view/MineView';
import JsonUser from '../model/JsonUser';
import HomeView from '../view/HomeView';
import SearchView from '../view/SearchView';

@Entry
@Component
struct IndexPage {
  @State
  private currentIndex: number = 0;

  private tabsController: TabsController = new TabsController();

  private user: JsonUser | null = router.getParams() as JsonUser;

  @Builder
  TabBuilder(title: string, index: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === index ? selectedImg : normalImg)
        .width(24)
        .height(24)

      Text(title)
        .margin({ top: 1 })
        .fontFamily("SerifBold")
        .fontSize(11)
        .fontColor(this.currentIndex === index ? "#1698CE" : "#6B6B6B")
    }
    .justifyContent(FlexAlign.Center)
    .height(26)
    .width("100%")
    .onClick(() => {
      this.currentIndex = index;
      this.tabsController.changeIndex(this.currentIndex);
    })
  }

  build() {
    Tabs({
      barPosition: BarPosition.End,
      controller: this.tabsController
    }) {
      TabContent() {
        // 首页内容
        HomeView({ user: this.user })
      }
      .padding({ left: 12, right: 12 })
      .backgroundColor("#F1F3F5")
      .tabBar(this.TabBuilder('首页', 0, $r('app.media.home_selected'), $r('app.media.home_normal')))

      TabContent() {
        // 详情内容
        SearchView({ user: this.user })
      }
      .padding({ left: 12, right: 12 })
      .backgroundColor("#F1F3F5")
      .tabBar(this.TabBuilder('探索', 1, $r('app.media.ic_gallery_discover_filled'), $r('app.media.ic_gallery_discover')))

      TabContent() {
        // 我的内容
        MineView({ user: this.user })
      }
      .padding({ left: 12, right: 12 })
      .backgroundColor("#F1F3F5")
      .tabBar(this.TabBuilder('我的', 2, $r('app.media.mine_selected'), $r('app.media.mine_normal')))
    }
    .width('100%')
    .backgroundColor(Color.White)
    .barHeight(56)
    .barMode(BarMode.Fixed)
    .onChange((index: number) => {
      this.currentIndex = index;
    })
    .onAppear(() => {
      this.tabsController.preloadItems([0, 1, 2]);
    })
  }
}