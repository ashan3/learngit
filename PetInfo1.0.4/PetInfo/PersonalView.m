//
//  PersonalView.m
//  MBA
//
//  Created by 海普科技  on 14-5-20.
//  Copyright (c) 2014年 海普科技 . All rights reserved.
//

#import "PersonalView.h"
#import "UIAlertView+ShowNotice.h"
@interface PersonalView ()

@end

@implementation PersonalView
@synthesize locatePicker;
@synthesize areaValue;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      self.title=@"个人中心";
    }
    return self;
}
- (void)dealloc {
  [nameField release];
  [addressField release];
  [emailField release];
  [locatePicker release];
  [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    nameField.text = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERPRC"];
    emailField.text = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"EMAIL"];
    
    addressField.text =[NSString stringWithFormat:@"%@ %@ %@",[[userDefaults objectForKey:@"userinfo"] objectForKey:@"PROVINCE"],[[userDefaults objectForKey:@"userinfo"] objectForKey:@"CITY"],[[userDefaults objectForKey:@"userinfo"] objectForKey:@"AREA"]];
    if ( [[[userDefaults objectForKey:@"userinfo"] objectForKey:@"SEX"] integerValue]==1) {
        sex = 1;
        UIButton *button = (UIButton *)[self.view viewWithTag:10];
        [button setImage:[UIImage imageNamed:@"radio.png"] forState:UIControlStateNormal];
        button.selected =NO;
        button = (UIButton *)[self.view viewWithTag:11];
        
        button.selected=YES;
        [button setImage:[UIImage imageNamed:@"radio_selected.png"] forState:UIControlStateNormal];
    }
  addressField.delegate=self;
    [self cancelLocatePicker];
  
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)setAreaValue:(NSString *)_areaValue
{
    if (![areaValue isEqualToString:_areaValue]) {
        areaValue = _areaValue;
        addressField.text = areaValue;
        
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    [nameField resignFirstResponder];
    [emailField resignFirstResponder];
    
      [self cancelLocatePicker];
    
}
#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        self.areaValue = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    NSLog(@"1-----");
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [nameField resignFirstResponder];
    [emailField resignFirstResponder];
    
    
    [self cancelLocatePicker];
    self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
        [self.locatePicker showInView:self.view];
    
    return NO;
}


-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sender:(id)sender{
    
    NSString *name = [nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *address = addressField.text;
    
    NSArray *strArray =[address componentsSeparatedByString:@" "];
    
    NSString *province = @"";
    NSString *city = @"";
    NSString *area = @"";
    
    if (strArray.count ==3) {
        province =[strArray objectAtIndex:0];
        
        city =[strArray objectAtIndex:1];
        area =[strArray objectAtIndex:2];
    }else if (strArray.count == 2){
        
        
        province =[strArray objectAtIndex:0];
        
        city =[strArray objectAtIndex:1];
        
        area = @"";
    }
    NSLog(@"%@ %@ %@",province,city,area);
    NSString *msg=@"";
    
    if([name length] == 0){
        msg=@"请输入用户名";
    }else if([email length] == 0){
        msg=@"请输入Email";
    }else if ([address length]==0){
           msg=@"请输入地址";
    }
    if(![msg isEqualToString:@""])
    {
      [UIAlertView showWithNotice:msg];
        return;
    }
    
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *userId = [[userDefaults objectForKey:@"userinfo"] objectForKey:@"USERID"];
  NSString *Url = [[NSString stringWithFormat:@"UserInfoService/updateUserInfo/%@/%@/%d/%@/%@/%@/%@",userId,name,sex,email,province,city,area] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  [DataService requestWithURL:Url andparams:nil andhttpMethod:@"GET" completeBlock:^(id result) {
    
    NSString *result1 = [result objectForKey:@"result"];
    if ([result1 isEqualToString:@"0"]) {
      [SVProgressHUD showSuccessWithStatus:@"修改成功"];
      NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
      NSMutableDictionary *dic =[[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"userinfo"]];
      
      NSArray *strArray =[addressField.text componentsSeparatedByString:@" "];
      NSString *province = @"";
      NSString *city = @"";
      NSString *area = @"";
      if (strArray.count ==3) {
        province =[strArray objectAtIndex:0];
        
        city =[strArray objectAtIndex:1];
        area =[strArray objectAtIndex:2];
      }else if (strArray.count == 2){
        province =[strArray objectAtIndex:0];
        city =[strArray objectAtIndex:1];
        area = @"";
      }
      
      [dic setObject:nameField.text forKey:@"USERPRC"];
      [dic setObject:emailField.text forKey:@"EMAIL"];
      [dic setObject:province forKey:@"PROVINCE"];
      [dic setObject:city forKey:@"CITY"];
      [dic setObject:area forKey:@"AREA"];
      [dic setObject:[NSNumber numberWithInteger:sex] forKey:@"SEX"];
      
      
      [userDefaults removeObjectForKey:@"userinfo"];
      [userDefaults setObject:dic forKey:@"userinfo"];
      
      [userDefaults synchronize]; //同步
      
      
    }else{
        [SVProgressHUD showErrorWithStatus:@"修改失败"];

    }
  } andErrorBlock:^(NSError *error) {
  }];
}


-(void)selectSex:(UIButton*)sender{
    
    if (sender.tag ==10) {
        
        if (sender.selected ==NO) {
            
            UIButton *button = (UIButton *)[self.view viewWithTag:11];
            
            [button setImage:[UIImage imageNamed:@"radio.png"] forState:UIControlStateNormal];
            
            [sender setImage:[UIImage imageNamed:@"radio_selected.png"] forState:UIControlStateNormal];
            
            sex =0;
            sender.selected =YES;
            button.selected =NO;
        }
        
    }else{
        
        if (sender.selected ==NO) {
            
            UIButton *button = (UIButton *)[self.view viewWithTag:10];
            
            [button setImage:[UIImage imageNamed:@"radio.png"] forState:UIControlStateNormal];
            
            [sender setImage:[UIImage imageNamed:@"radio_selected.png"] forState:UIControlStateNormal];
            
            sex =1;
            sender.selected =YES;
            button.selected =NO;
        }

        
    }
    
    
    
}

@end
