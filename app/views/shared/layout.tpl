<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Some Inc.">
    <meta name="author" content="Tal Lannder">
    <link rel="icon" href="/static/img/favicon.ico">

    <title>{{.Title}}</title>
    <!-- Bootstrap core CSS -->
    <link rel="stylesheet" href="/static/twbs/3.3.6/css/bootstrap.min.css">
    <!-- Custom Global styles for this template -->
    <link rel="stylesheet" href="/static/css/globalStyles.css">

    <script src="/static/jquery/jquery-2.1.4.min.js"></script>
    <script src="/static/twbs/3.3.6/js/bootstrap.min.js"></script>
    <script src="/static/js/password_feedback.js"></script>
  </head>
  <body style="padding-bottom: 35px">
{{.Header}}
{{.LayoutContent}}
{{.Footer}}
  </body>
</html>
