<div class="container" style="padding-top: 80px" id="content">
  <div class="row">
    <form class="form-horizontal" method="POST">
      <div class="form-group{{if .Errors.First}} has-error has-feedback{{end}}">
        <label for="First" class="col-sm-2 control-label">First name</label>
        <div class="col-sm-8">
          <input type="text" name="First" id="First" class="form-control" value="{{.User.First}}">
          {{if .Errors.First}}<span class="help-block">{{.Errors.First}}</span>{{end}}
        </div>

        <div class="col-sm-8">
            <h4>Upload File</h4>
            <label class="btn btn-primary">
                Browse&hellip; <input type="file" style="display: none;">
            </label>
        </div>

      </div>

      {{.User}}
      <div class="form-group">
        <div class="col-sm-offset-2 col-sm-8">
          <button type="submit" class="btn btn-primary" value="Update">Update</button>
        </div>
      </div>
    </form>
  </div>
  <hr>
</div><!-- end container -->
