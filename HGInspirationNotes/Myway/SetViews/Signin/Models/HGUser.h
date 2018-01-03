//
//  HGUser.h
//  HGInspirationNotes
//
//  Created by 小雨很美 on 2017/12/17.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

#import "HGBaseModel.h"
@interface HGStaff: HGBaseModel
@property (nonatomic, strong) NSNumber *ID; //id
@property (nonatomic, strong) NSNumber *company;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *bankAccount;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *department;
@property (nonatomic, strong) NSNumber *user;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *birthday;

//var birthday: String?
//var deptName: String?
//var email: String?
//var endDate: String?
//var extcode: String?
//var extid: Int?
//var extname: String?
//var firstName: String?
//var fullName: String?
//var gender: String?
//var groupId: Int?

//var idExpirationDate: String?
//var idType: String?
//var identification: String?
//var inviteStatus: String?
//var isAdmin: Bool?
//var isCorpMobile: Bool?
//var lastName: String?
//var lastupdate: String?
//var missionneedapproval: Bool?
//var mobile: String?

//var nationality: String?
//var needfillapplication: Bool?
//var parent: Int?
//var parentName: Bool?
//var personrank: Int?
//var phone: String?
//var position: String?
//var reportAgent: String?
//var shortName: String?
//var startDate: String?
//var status: String?
//var subBankName: String?
//var systemusedstatus: String?
//var user: Int?
//var workPlace: String?
//var wxno: String?
//
//var dataDict: Dictionary<String, Any>?
@end



@interface HGUser : HGBaseModel
@property (nonatomic, strong) HGStaff *staff;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *usertype;
@property (nonatomic, strong) NSNumber *company;
@property (nonatomic, copy) NSString *companyname;
@property (nonatomic, strong) NSNumber *corpVersion;
@property (nonatomic, strong) NSNumber *department;
@property (nonatomic, strong) NSNumber *groupid;

@property (nonatomic) NSInteger newMessageCount;
@property (nonatomic) NSInteger newOrderTaskCount;
@property (nonatomic) NSInteger newReimTaskCount;
@property (nonatomic) NSInteger newTravelTaskCount;
@property (nonatomic, strong) NSNumber *staffId;
@property (nonatomic, strong) NSNumber *subsidyStandard;

@property (nonatomic) BOOL isDummy;
@property (nonatomic) BOOL isHttps;
@property (nonatomic) BOOL logged;
@property (nonatomic) BOOL isAdmin;

@property (nonatomic) BOOL success;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *orderTicketType;
@property (nonatomic, copy) NSString *payMode;
@property (nonatomic, copy) NSString *reportAgent;
@property (nonatomic, copy) NSArray *roles ;
@property (nonatomic, copy) NSDictionary *tabsdigist;

@property (nonatomic, copy) NSString *registerType;

//@property (nonatomic, copy) NSString *address;
//@property (nonatomic, copy) NSString *bankAccount;
//@property (nonatomic, copy) NSString *bankName;
//@property (nonatomic, copy) NSString *birthday;
//@property (nonatomic, copy) NSString *code;
//
//
//@property (nonatomic, copy) NSString *deptName;
//@property (nonatomic, copy) NSString *email;
//@property (nonatomic, copy) NSString *endDate;
//
//
//@property (nonatomic, strong) NSNumber *extid;
//
//@property (nonatomic, copy) NSString *extname;
//@property (nonatomic, copy) NSString *firstName;
//@property (nonatomic, copy) NSString *fullName;
//@property (nonatomic, copy) NSString *gender;
//
//@property (nonatomic, strong) NSNumber *groupId;
//@property (nonatomic, strong) NSNumber *ID; //id
//
//@property (nonatomic, copy) NSString *idExpirationDate;
//@property (nonatomic, copy) NSString *idType;
//@property (nonatomic, copy) NSString *identification;
//@property (nonatomic, copy) NSString *inviteStatus;
//
//@property (nonatomic) BOOL isAdmin;
//@property (nonatomic) BOOL isCorpMobile;
//
//@property (nonatomic, copy) NSString *lastName;
//@property (nonatomic, copy) NSString *lastupdate;
//
//@property (nonatomic) BOOL missionneedapproval;
//
//@property (nonatomic, copy) NSString *mobile;
//@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *nationality;
//
//@property (nonatomic) BOOL needfillapplication;
//@property (nonatomic) BOOL parentName;
//@property (nonatomic, strong) NSNumber *parent;
//@property (nonatomic, strong) NSNumber *personrank;
//
//@property (nonatomic, copy) NSString *phone;
//@property (nonatomic, copy) NSString *position;
//@property (nonatomic, copy) NSString *reportAgent;
//@property (nonatomic, copy) NSString *shortName;
//@property (nonatomic, copy) NSString *startDate;
//@property (nonatomic, copy) NSString *status;
//@property (nonatomic, copy) NSString *subBankName;
//@property (nonatomic, copy) NSString *systemusedstatus;
//
//
//@property (nonatomic, copy) NSString *workPlace;
//@property (nonatomic, copy) NSString *wxno;



@property (nonatomic, copy) NSDictionary *dataDict;
@end
