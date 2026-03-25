/// 为截 App Store 引导页（[WelcomePage]）素材：冷启动在已存在保险库时也会先显示引导。
/// 在引导页点「开始使用」会恢复原锁定/解锁状态，不会进入设密。截完务必改回 `false` 再发布。
const bool kAlwaysShowOnboardingOnLaunch = false;
