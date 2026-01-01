# Agora通話機能のセットアップ手順

## 1. Agoraアカウントの作成とApp IDの取得

### 手順：

1. **Agoraコンソールにアクセス**
   - https://console.agora.io/ にアクセス
   - アカウントを作成（無料プランでOK）

2. **新しいプロジェクトを作成**
   - 「Create a New Project」をクリック
   - プロジェクト名を入力（例：FaceChat）
   - 「Secured mode: APP ID」を選択（開発中はテスト用）
   - 「Submit」をクリック

3. **App IDをコピー**
   - プロジェクト一覧から作成したプロジェクトの「App ID」をコピー

4. **App IDを設定**
   - `lib/config/agora_config.dart` を開く
   - `YOUR_APP_ID_HERE` を コピーしたApp IDに置き換え
   
   ```dart
   static const String appId = 'ここにApp IDを貼り付け';
   ```

## 2. パッケージのインストール

ターミナルで以下のコマンドを実行：

```bash
cd facechat_app
flutter pub get
```

## 3. 実機で動作確認

1. 実機を接続
2. アプリをビルド・実行
3. 2つのアカウントで登録
4. お互いを友達追加
5. 「通話」ボタンをタップして通話開始

## 注意事項

- **Agoraの無料プラン**: 月10,000分まで無料
- **実機が必要**: エミュレータでは通話機能が正常に動作しない場合があります
- **権限の許可**: 初回起動時にカメラ・マイクの権限を許可してください

## トラブルシューティング

### App IDエラーが出る場合
- `agora_config.dart` のApp IDが正しく設定されているか確認
- App IDは32文字の英数字です

### 通話が繋がらない場合
- 両方のユーザーが同じチャンネル名を使用しているか確認
- インターネット接続を確認
- カメラ・マイクの権限が許可されているか確認

### ビルドエラーが出る場合
```bash
flutter clean
flutter pub get
flutter run
```

## 本番環境への移行

本番環境では「トークン認証」が必要です：
1. Agoraコンソールで「Token Server」を設定
2. サーバー側でトークンを生成
3. `agora_config.dart` の `token` にトークンを設定
