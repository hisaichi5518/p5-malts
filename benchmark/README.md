## サーバを立ち上げる

```
plackup -s Starman -E production --workers=10 -a amon/lite.psgi
plackup -s Starman -E production --workers=10 -a malts/lite.psgi
plackup -s Starman -E production --workers=10 -a ark/app.psgi
plackup -s Starman -E production --workers=10 -a dancer/lite.psgi
plackup -s Starman -E production --workers=10 -a kossy/lite.psgi
MOJO_MODE=production  plackup -s Starman -E production --workers=10 -a mojolicious/lite.psgi
```

## 測る

```
ab -n 1000 -c 10 http://0:5000/
ab -n 1000 -c 10 http://localhost:5000/
```
