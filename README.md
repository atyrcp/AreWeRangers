# AreWeRangers

開發平台：iOS  
使用語言：Swift

包含技術：
1. 純 code layout、使用 xib 檔
2. 串接 JSON(Codable 與 JSONSerialization)，並客製 model
3. ScrollView 中嵌入 collectionView 並支援滑動
4. 增加 gesture（tap）
5. 用 CoreData 離線儲存
6. 自訂 Protocol 以及 Extension

基本功能（皆完成）：
1. 連接 Endpoint, 呈現資料（圖像、名字...等）
2. 三個分頁
3. 呈現兩個類型內容（人物、只有圖像）
3. 向下拉動刷新內容（隨機頁）
4. 無限滾動（不斷載入下一頁內容，若所有分頁皆呈現完畢，則重複呈現）

進階功能（皆完成）：
1. 所有 UI 盡量和示意圖一致（顏色、位置、呈現方式...等）
2. 可左右滑動顯示分頁
3. 支援離線緩存（注意：請 build 到實機上或在模擬器中向上滑動關閉 App，勿直接在 Xcode 中按停止鍵）
