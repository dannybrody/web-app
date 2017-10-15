package models

import (
	"time"
	"github.com/astaxie/beego/orm"
)


type Account struct {
	Uid                            string `orm:"pk"`
	First                          string
	Last                           string
	Email                          string `orm:"unique"`
	Phone1                         string
	Phone2                         string
	Address                        string
	Password                       string
	Registration_uid               string
	Registration_date              time.Time `orm:"auto_now_add;type(datetime)"`
	Password_reset_uid             string
	Files 						   []*File `orm:"reverse(many)"`
}

type File struct {
    Id    						   int
    Filename					   string
    Location					   string `orm:"unique"`
    Account  					   *Account  `orm:"rel(fk)"`
    Registration_date              time.Time `orm:"auto_now_add;type(datetime)"`
}


func (account Account) CopySignUpForm(form *FormAccountSignUp) Account {
  account.First = form.First
  account.Last = form.Last
  account.Email = form.Email
  account.Password = form.Password

  return account
}


func (account Account) CopyUpdateForm(form *FormAccountUpdate) Account {
  account.First = form.First
  account.Last = form.Last
  account.Email = form.Email
  account.Phone1 = form.Phone1
  account.Phone2 = form.Phone2
  account.Address = form.Address

  return account
}


func init() {
	orm.RegisterModel(new(Account),new(File))
}

// func main() {
//     o := orm.NewOrm()
//     o.Using("default") // Using default, you can use other database

//     profile := new(Profile)
//     profile.Age = 30

//     user := new(User)
//     user.Profile = profile
//     user.Name = "slene"

//     fmt.Println(o.Insert(profile))
//     fmt.Println(o.Insert(user))
// }
