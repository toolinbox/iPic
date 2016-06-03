# What's iPic Upload Service

iPic is perfert to upload image. iPic is not only a standalone app, but could also provide upload service to help other apps easily upload images.



# Pre-Condition to Use iPic Upload Service

- iPic was installed (could locate anywhere but not only `/Applications`).
- iPic was ever launched for at least one time.



Download iPic [here]()



# How to Use iPic Upload Service

Now iPic upload service support using URL scheme to communicate between your app and iPic.



Demo URL scheme to launch iPic:

`iPic:///upload?filePath=/Users/jason/Downloads/test.jpg&callback=iPicDemo:///uploadResult`

- `iPic:///upload`
  - Fixed for iPic upload service.
- `filePath`
  - Full path of image file.
- `callback`
  - URL scheme of your app used to callback with url of image.



Demo URL scheme to callback your app:

`iPicDemo:///uploadResult?filePath=/Users/jason/Downloads/1753061.jpg&url=http://img.com/test.jpg`

- `iPicDemo:///uploadResult`
  - URL Scheme supported by you app.
- `filePath`
  - Same with the filePath your app launched iPic.
  - Could be used to identifiy different images if you upload multi-ones.
- `url`
  - URL for image file.
  - If upload failed, no such parameter.



Note:

- Could only upload one image at a time. If you need to upload multi-images, call the URL scheme multi-times. The callback will be called one by one.

- Hasn't support error code yet.

  ​

You can also check the demo project for details: [UploadImageDemo]()



# 什么是 iPic 上传服务

图床神器 iPic 可以方便的上传图片、插入博客。不仅是独立的 App，iPic 同样提供开放的上传服务，你的 App 可以方便的调用 iPic 上传服务进行图片的上传。



# 使用 iPic 上传服务的条件

- iPic 已安装（可位于任意位置，不一定是 `/Applications`）
- iPic 至少被运行一次



[点此下载 iPic]()



# 如何使用 iPic 上传服务

目前 iPic 上传服务支持使用 URL scheme 进行通信。



调用 iPic 上传服务的示例 URL scheme:

`iPic:///upload?filePath=/Users/jason/Downloads/test.jpg&callback=iPicDemo:///uploadResult`

- `iPic:///upload`
  - 固定值
- `filePath`
  - 图片文件的完整路径
- `callback`
  - 用于 iPic 上传服务回调你的 App



iPic 上传服务回调你的 App 的示例 URL scheme:

`iPicDemo:///uploadResult?filePath=/Users/jason/Downloads/1753061.jpg&url=http://img.com/test.jpg`

- `iPicDemo:///uploadResult`
  - 你的 App 支持的 URL Scheme
- `filePath`
  - 和调用 iPic 上传服务时的路径完全一致
  - 用于上传多张图片时获取不同图片对应的 url
- `url`
  - 图片文件的 URL
  - 如果上传失败，回调中无此参数



注：

- 一次调用仅支持上传一张图片。如需上传多张，多次调用即可。回调将依次执行

- 目前尚未支持错误码

  ​

更多细节，可以查看示例项目：[UploadImageDemo]()

