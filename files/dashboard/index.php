<!DOCTYPE HTML>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Minecraft RCON</title>
    <link rel="stylesheet" type="text/css" href="static/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="static/css/bootstrap-icons.css" />
    <link rel="stylesheet" type="text/css" href="static/css/style.css">
    <script type="text/javascript" src="static/js/jquery-1.12.0.min.js"></script>
    <script type="text/javascript" src="static/js/jquery-migrate-1.2.1.min.js"></script>
    <script type="text/javascript" src="static/js/jquery-ui-1.12.0.min.js"></script>
    <script type="text/javascript" src="static/js/bootstrap.min.js" ></script>
    <script type="text/javascript" src="static/js/script.js" ></script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="shortcut icon" type="image/png" href="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA+5pVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgeG1wTU06T3JpZ2luYWxEb2N1bWVudElEPSJ1dWlkOjY1RTYzOTA2ODZDRjExREJBNkUyRDg4N0NFQUNCNDA3IiB4bXBNTTpEb2N1bWVudElEPSJ4bXAuZGlkOkI0N0JDRjhEMDY5MTExRTI5OUZEQTZGODg4RDc1ODdCIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOkI0N0JDRjhDMDY5MTExRTI5OUZEQTZGODg4RDc1ODdCIiB4bXA6Q3JlYXRvclRvb2w9IkFkb2JlIFBob3Rvc2hvcCBDUzYgKE1hY2ludG9zaCkiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDowMTgwMTE3NDA3MjA2ODExODA4M0ZFMkJBM0M1RUU2NSIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDowNjgwMTE3NDA3MjA2ODExODA4M0U3NkRBMDNEMDVDMSIvPiA8ZGM6dGl0bGU+IDxyZGY6QWx0PiA8cmRmOmxpIHhtbDpsYW5nPSJ4LWRlZmF1bHQiPmdseXBoaWNvbnM8L3JkZjpsaT4gPC9yZGY6QWx0PiA8L2RjOnRpdGxlPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PgFdWUIAAAExSURBVHjaxFUBEcIwDFxRMAmVMAnBQSVMAhImAQlIQAJzUBzgAByU9C7jspCsZdc7cvfHyNbPLcn/upRSVwOMiEiEW+05R4c3wznX48+T5/Cc6yrioJBNCBBpUJ4D+R8xflUQbbiwNuRrjzghHiy/IOcy4YC4svy44mTkk0KyF2Hh5S26de0i1rRoLya1RVTANyjQc065RcF45TvimFeT1vNIOS3C1xblqnRD25ZoCK8X4vs8T1z9orFYeGXYUHconI2OLswoKRbFlX5S8i9BFlK0irlAAhu3Q4F/5v0Ea8hy9diQrefB0sFoDWuRPxGPBvnKJrQCQ2uhyQLXBgXOlptCQzcdNKvwDd3UW27KhzyxgW5aQm5L8YMj5O8rLAGUBQn//+gbfvQS9jzXDuMtwAATXCNvATubRQAAAABJRU5ErkJggg==" />
</head>
<body>
  <div class="container-fluid d-flex flex-column pt-3" id="content">
    <div class="alert alert-info" id="alertMessage">
      Minecraft RCON
    </div>
    <div class="card mb-3">
      <h3 class="card-header placeholder-glow">
        <span><i class="bi bi-lightning-charge"></i> Server</span>
        <span class="float-end h5 m-0">
          <span class="align-middle">
            <span class="d-none d-sm-inline">Version: </span><span class="d-inline d-sm-none text-info">v</span><span class="placeholder" id="serverVersion">0.00.0</span> - 
            <span class="d-none d-sm-inline">Status: </span><span class="placeholder" id="serverStatus">______</span>
          </span>
        </span>
      </h3>
      <div class="card-body mx-auto" id="serverControl">
        <button class="btn btn-success"><i class="bi bi-lightbulb"></i><span class="d-none d-sm-inline"> Start</span></button>
        <button class="btn btn-success"><i class="bi bi-play"></i><span class="d-none d-sm-inline"> Resume</span></button>
        <button class="btn btn-warning"><i class="bi bi-arrow-repeat"></i><span class="d-none d-sm-inline"> Restart</span></button>
        <button class="btn btn-warning"><i class="bi bi-pause"></i><span class="d-none d-sm-inline"> Pause</span></button>
        <button class="btn btn-danger"><i class="bi bi-lightbulb-off"></i><span class="d-none d-sm-inline"> Stop</span></button>
        <!--<button class="btn btn-info"><i class="bi bi-arrow-up-circle"></i><span class="d-none d-sm-inline"> Update</span></button>-->
      </div>
    </div>
    <div class="card flex-grow-1 scroll-child">
      <h3 class="card-header">
        <i class="bi bi-terminal"></i> Console
        <div class="btn-group btn-group-sm float-end">
          <a class="btn btn-secondary" href="http://minecraft.gamepedia.com/Commands" target="_blank"><i class="bi bi-question-circle-fill"></i><span class="d-none d-sm-inline"> Commands</span></a>
          <a class="btn btn-secondary" href="http://www.minecraftinfo.com/idlist.htm" target="_blank"><i class="bi bi-info-circle-fill"></i><span class="d-none d-sm-inline"> Items IDs</span></a>
        </div>
      </h3>
      <div id="consoleContent" class="card-body scroll-y">
        <ul class="list-group" id="groupConsole"></ul>
      </div>
    </div>
    <div class="input-group my-3" id="consoleCommand">
      <span class="input-group-text">
        <input id="chkAutoScroll" type="checkbox" checked="true" autocomplete="off" /><i class="bi bi-arrow-down"></i>
      </span>
      <div id="txtCommandResults"></div>
      <input type="text" class="form-control" id="txtCommand" />
      <div class="input-group-btn">
        <button type="button" class="btn btn-primary" id="btnSend"><i class="bi bi-send"></i><span class="d-none d-sm-inline"> Send</span></button>
        <button type="button" class="btn btn-warning" id="btnClearLog"><i class="bi bi-eraser-fill"></i><span class="d-none d-sm-inline"> Clear</span></button>
      </div>
    </div>
  </div>
</body>
</html>