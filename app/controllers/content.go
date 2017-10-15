package controllers

import (
  // "golang.org/x/crypto/bcrypt"
  "github.com/astaxie/beego"
  "github.com/astaxie/beego/orm"
  // "github.com/astaxie/beego/validation"
  _ "github.com/astaxie/beego/cache/redis"
  "app/models"
  "fmt"
  "github.com/aws/aws-sdk-go/aws/session"
  "github.com/aws/aws-sdk-go/aws"
  "github.com/aws/aws-sdk-go/service/s3"
  "github.com/aws/aws-sdk-go/aws/awserr"
)
var (

  aws_region = beego.AppConfig.String("aws_region")
  bucket = beego.AppConfig.String("bucket")
  sess = session.New(&aws.Config{
    Region: aws.String(aws_region),
  })
  svc = s3.New(sess)

)

type ContentController struct {
  AccountController
}


func (this *ContentController) Get() {
  beego.Debug("In ContentController:Get - Start")

  o := orm.NewOrm()
  o.Using("default")

  user := models.Account{Uid: this.session["uid"].(string)}

  beego.Debug("In ContentController:Get - Reading user from the database")

  err := o.Read(&user)

  if err != nil {
    flash := beego.NewFlash()
    flash.Error("Internal server error - Please try later or let us know that something whent wrong.")
    flash.Store(&this.Controller)
    this.DelSession("session")
    this.Redirect("/accounts/signin", 303)
  }

  this.Data["User"] = user
  this.Data["ProfileActive"] = true

}//end ContentController:Get() func


func (this *ContentController) Post() {
  beego.Debug("In ContentController:Post - Start")
  file, header, err := this.GetFile("file")
  if err != nil {
    fmt.Println(err)
  }

  key := "web-app/uploads/"+this.session["uid"].(string)+"/"+header.Filename
  input := &s3.PutObjectInput{
      Body:                 aws.ReadSeekCloser(file),
      Bucket:               aws.String(bucket),
      Key:                  aws.String(key),
  }
  result, err := svc.PutObject(input)
  if err != nil {
      if aerr, ok := err.(awserr.Error); ok {
          switch aerr.Code() {
          default:
              fmt.Println(aerr.Error())
              beego.Error("Content:Post - error uploading to s3: ", aerr.Error())
          }
      } else {
          fmt.Println(err.Error())
          beego.Error("Content:Post - error uploading to s3: ", aerr.Error())
      }
      this.Redirect("/accounts/content", 303)
  }

  fmt.Println(result)

  o := orm.NewOrm()
  user := models.Account{Uid: this.session["uid"].(string)}
  file := models.File{}
  file.Filename = header.Filename
  file.Location = "location"
  file.Account = user
  _, err = o.Insert(&file)
    if err != nil {
    beego.Error("SignupController:Post - Got err inserting file to the database: ", err)
    return
  }

  this.Redirect("/accounts/content", 303)

}
