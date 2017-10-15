<div class="container" style="padding-top: 80px" id="content">
  <div class="row">
    <form class="form-horizontal"  method="post" enctype="multipart/form-data">
      <label for="file" class="col-sm-2 control-label">Upload File</label>
      <div class="col-sm-8">
        <input type="file" name="file" class="form-control" id="file">
        {{if .Errors.file}}<span class="help-block">{{.Errors.file}}</span>{{end}}
      </div>

      {{.User.Files}}
      <div class="form-group">
        <div class="col-sm-offset-2 col-sm-8">
          <button type="submit" class="btn btn-primary" value="Update">Upload</button>
        </div>
      </div>
    </form>
  </div>
  <hr>
</div><!-- end container -->
