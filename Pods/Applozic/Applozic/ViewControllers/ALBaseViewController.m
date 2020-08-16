//
//  ALBaseViewController.m
//  ChatApp
//
//  Created by Kumar, Sawant (US - Bengaluru) on 9/23/15.
//  Copyright (c) 2015 AppLogic. All rights reserved.
//

static CGFloat NAVIGATION_TEXT_SIZE = 20;
static CGFloat LAST_SEEN_LABEL_SIZE = 10;
static CGFloat TYPING_LABEL_SIZE = 12.5;

#import "ALBaseViewController.h"
#import "ALUtilityClass.h"
#import "ALUserDefaultsHandler.h"
#import "ALConstant.h"
#import "ALApplozicSettings.h"
#import "ALChatLauncher.h"
#import "ALMessagesViewController.h"
#import "ALNavigationController.h"
#import "ALApplicationInfo.h"
#import "ALRegisterUserClientService.h"

static CGFloat const sendTextViewCornerRadius = 15.0f;

@interface ALBaseViewController ()

@property (nonatomic,retain) UIButton * rightViewButton;
-(void)parseRestrictedWordFile;

@end

@implementation ALBaseViewController
{
    CGFloat typingIndicatorHeight;
    CGRect tempFrame;
    
    CGRect keyboardEndFrame;
    CGFloat navigationWidth;
    int paddingForTextMessageViewHeight;
    ALApplicationInfo * applicationInfo;
    ALRegisterUserClientService * registerUserClientService;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpTableView];
    [self setUpTheming];
    
    self.sendMessageTextView.clipsToBounds = YES;
    self.sendMessageTextView.layer.cornerRadius = sendTextViewCornerRadius;
//    self.sendMessageTextView.frame.size.height/5;
    
    self.sendMessageTextView.textContainer.lineBreakMode = NSLineBreakByCharWrapping;
//    self.sendMessageTextView.textContainerInset = UIEdgeInsetsMake(self.attachmentOutlet.frame.origin.x, // Top
//                                                                   self.attachmentOutlet.frame.size.width,// Left
//                                                                   self.attachmentOutlet.frame.origin.y, // Bottom
//                                                                   self.attachmentOutlet.frame.size.width/4);   // Right
    self.sendMessageTextView.delegate = self;
/*    self.placeHolderTxt = @"Write a Message...";
    self.sendMessageTextView.text = self.placeHolderTxt;
    */
    self.placeHolderColor = [ALApplozicSettings getPlaceHolderColor];
    self.sendMessageTextView.textColor = self.placeHolderColor;
    self.sendMessageTextView.backgroundColor = [ALApplozicSettings getMsgTextViewBGColor];
    
    
    if ([ALUtilityClass parsedALChatCostomizationPlistForKey:APPLOZIC_CHAT_BACKGROUND_COLOR])
        self.mTableView.backgroundColor = (UIColor *)[ALUtilityClass parsedALChatCostomizationPlistForKey:APPLOZIC_CHAT_BACKGROUND_COLOR];
    else
        self.mTableView.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1];
    
    
    // Navigation width is constant
    navigationWidth = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;

    
    // Set Beak's Color : Dependant of SendMessage-TextView
    self.beakImageView.image = [_beakImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.beakImageView setTintColor:self.sendMessageTextView.backgroundColor];
    if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
        self.sendButton.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        self.beakImageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        self.sendMessageTextView.textAlignment = NSTextAlignmentRight;
    }
    
    [self parseRestrictedWordFile];
    applicationInfo = [[ALApplicationInfo alloc] init];
    if ([applicationInfo isChatSuspended]) {
        registerUserClientService = [[ALRegisterUserClientService alloc] init];
        [registerUserClientService syncAccountStatusWithCompletion:^(ALRegistrationResponse *response, NSError *error) {
            if(error || !response.isRegisteredSuccessfully) {
                ALSLog(ALLoggerSeverityError, @"Failed to sync the account status");
            }
        }];
    }
}

-(void)parseRestrictedWordFile
{
    if(![ALApplozicSettings getMessageAbuseMode])
    {
        return;
    }
    
    NSBundle *bundle = [NSBundle mainBundle];
    ALSLog(ALLoggerSeverityInfo, @":: BUNDLE_NAME :: %@",bundle.bundleIdentifier);
    NSString *path = [bundle pathForResource:@"restrictWords" ofType:@"txt"];
    ALSLog(ALLoggerSeverityInfo, @":: FILE_PATH :: %@",path);
    NSError *error = nil;
    NSString *fileString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    ALSLog(ALLoggerSeverityError, @"ERROR(IF-ANY) WHILE IMPORT WORD FILE :: %@",error.description);
    if (!error)
    {
        self.wordArray = [NSArray arrayWithArray:[fileString componentsSeparatedByString:@","]];
    }
}

-(void)setUpTableView
{
    UIButton * mLoadEarlierMessagesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    mLoadEarlierMessagesButton.frame = CGRectMake(self.view.frame.size.width/2-90, 15, 180, 30);
    [mLoadEarlierMessagesButton setTitle:@"Load Earlier" forState:UIControlStateNormal];
    [mLoadEarlierMessagesButton setBackgroundColor:[UIColor whiteColor]];
    mLoadEarlierMessagesButton.layer.cornerRadius = 3;
    [mLoadEarlierMessagesButton addTarget:self action:@selector(loadChatView) forControlEvents:UIControlEventTouchUpInside];
    [mLoadEarlierMessagesButton.titleLabel setFont:[UIFont fontWithName:[ALApplozicSettings getFontFace] size:14]];
    [self.mTableHeaderView addSubview:mLoadEarlierMessagesButton];

}

-(void)setUpTheming
{
    
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self setCustomBackButton]];
    UIBarButtonItem * refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                    target:self action:@selector(refreshTable:)];
    
    self.callButton = [[UIBarButtonItem alloc] initWithCustomView:[self customCallButtonView]];
    self.closeButton = [[UIBarButtonItem alloc] initWithCustomView:[self customCloseButtonView]];

    
    if(self.individualLaunch)
    {
        [self.navigationItem setLeftBarButtonItem:barButtonItem];
    }
    
    self.navRightBarButtonItems = [NSMutableArray new];
    

    if(![ALApplozicSettings isRefreshButtonHidden])
    {
        [self.navRightBarButtonItems addObject:refreshButton];
    }
    
    if([ALApplozicSettings getCustomNavigationControllerClassName])
    {
       ALNavigationController * customnavController = (ALNavigationController*)self.navigationController;
       
       NSMutableArray * customButtons = [customnavController getCustomButtons];
       
       for(UIView* buttonView in customButtons)
       {
           UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
           [self.navRightBarButtonItems addObject:barButtonItem];
       }
       
    }
    self.navigationItem.rightBarButtonItems = [self.navRightBarButtonItems mutableCopy];
    
    self.label = [[UILabel alloc] init];
    self.label.backgroundColor = [UIColor clearColor];
    [self.label setFont:[UIFont fontWithName:[ALApplozicSettings getFontFace] size:LAST_SEEN_LABEL_SIZE]];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.navigationController.navigationBar addSubview:self.label];
    
    typingIndicatorHeight = 30;
    self.typingLabel.backgroundColor = [ALApplozicSettings getBGColorForTypingLabel];
    self.typingLabel.textColor = [ALApplozicSettings getTextColorForTypingLabel];
    [self.typingLabel setFont:[UIFont fontWithName:[ALApplozicSettings getFontFace] size:TYPING_LABEL_SIZE]];
    self.typingLabel.textAlignment = NSTextAlignmentLeft;

    if([ALApplozicSettings isDropShadowInNavigationBarEnabled])
    {
        [self dropShadowInNavigationBar];
    }
    
}

-(void)dropShadowInNavigationBar
{
    self.navigationController.navigationBar.layer.shadowOpacity = 0.5;
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
    self.navigationController.navigationBar.layer.shadowRadius = 10;
    self.navigationController.navigationBar.layer.masksToBounds = NO;
}

-(void)loadChatView {
    
}

-(void)postMessage {
    
}

-(void)back:(id)sender {
    
    UIViewController *  uiController = [self.navigationController popViewControllerAnimated:YES];
    if(!uiController ){
        if(self.individualLaunch){
            [self  dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

-(void)refreshTable:(id)sender {
    
}

-(void)attachmentAction{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];

    [self.navigationController.navigationBar setTitleTextAttributes: @{
                                                                       NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                       NSFontAttributeName:[UIFont fontWithName:[ALApplozicSettings getFontFace]
                                                                                                            size:NAVIGATION_TEXT_SIZE]
                                                                       }];
    
    if([ALApplozicSettings getColorForNavigation] && [ALApplozicSettings getColorForNavigationItem])
    {
        
        [self.navigationController.navigationBar setTitleTextAttributes: @{
                                                                           NSForegroundColorAttributeName:[ALApplozicSettings getColorForNavigationItem],
                                                                           NSFontAttributeName:[UIFont fontWithName:[ALApplozicSettings getFontFace]
                                                                                                               size:NAVIGATION_TEXT_SIZE]
                                                                           }];
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar setBarTintColor:[ALApplozicSettings getColorForNavigation]];
        [self.navigationController.navigationBar setTintColor:[ALApplozicSettings getColorForNavigationItem]];
    
        [self.navigationController.navigationBar addSubview:[ALUtilityClass setStatusBarStyle]];
        [self.label setTextColor:[ALApplozicSettings getColorForNavigationItem]];
       
    }

    [self sendButtonUI];
    
    tempFrame = self.noConversationLabel.frame;
    
    paddingForTextMessageViewHeight  = 2;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /*  CHECK PRICING PACKAGE */
    [self checkPricingPackageAndShowMessage];
}

-(void)checkPricingPackageAndShowMessage
{
    if([applicationInfo isChatSuspended]) {
        [ALUtilityClass showAlertMessage:@"Please Contact Applozic to activate chat in your app" andTitle:@"ALERT"];
    }
    
}

-(void)sendButtonUI
{
    [self.sendButton setBackgroundColor:[ALApplozicSettings getColorForSendButton]];
   self.sendButton.layer.cornerRadius = sendTextViewCornerRadius + 5;
    self.sendButton.layer.masksToBounds = YES;
    
    [self.typingMessageView sendSubviewToBack:self.typeMsgBG];
    UIImage * image = [[ALUtilityClass getImageFromFramworkBundle:@"TYMSGBG.png"]
                       resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 10, 20)];
    
    [self.typeMsgBG setImage:image];
    [self.typingMessageView setBackgroundColor:[ALApplozicSettings getColorForTypeMsgBackground]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self removeRegisteredKeyboardNotifications];
}

// Setting up keyboard notifications.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeRegisteredKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];

}

//------------------------------------------------------------------------------------------------------------------
#pragma mark - Keyboard Post Notifacations
//------------------------------------------------------------------------------------------------------------------

-(void) keyBoardWillShow:(NSNotification *) notification
{
    NSString * theAnimationDuration = [self handleKeyboardNotification:notification];

    self.checkBottomConstraint.constant = -1 * keyboardEndFrame.size.height +
    self.bottomLayoutGuide.length;

    [UIView animateWithDuration:theAnimationDuration.doubleValue animations:^{
        [self.view layoutIfNeeded];
        [self scrollTableViewToBottomWithAnimation:YES];
    } completion:^(BOOL finished) {
        if (finished) {
            [self scrollTableViewToBottomWithAnimation:YES];
        }
    }];
}

-(void) keyBoardWillHide:(NSNotification *) notification
{
    NSString * theAnimationDuration = [self handleKeyboardNotification:notification];
    
    self.checkBottomConstraint.constant = 0;
//    self.noConversationLabel.frame = tempFrame;
    
    [UIView animateWithDuration:theAnimationDuration.doubleValue animations:^{
        [self.view layoutIfNeeded];
        
    }];
  
}

-(NSString *)handleKeyboardNotification:(NSNotification *) notification{
    
    NSDictionary * theDictionary = notification.userInfo;
    NSString * theAnimationDuration = [theDictionary valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    keyboardEndFrame = [(NSValue *)[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
//    self.typingLabel.frame = CGRectMake(0,
//                                        keyboardEndFrame.origin.y - (self.typingMessageView.frame.size.height + typingIndicatorHeight + navigationWidth),
//                                        self.view.frame.size.width, typingIndicatorHeight);
    return theAnimationDuration;
}

-(void)setHeightOfTextViewDynamically
{
    
    [self setHeightOfTextViewDynamically:YES];
    
}

-(void)setHeightOfTextViewDynamically:(BOOL)scroll
{
    
    [self subProcessSetHeightOfTextViewDynamically];
    if(scroll)
    {
        [self scrollTableViewToBottomWithAnimation:YES];
    }
    [self.view layoutIfNeeded];
    
}

-(void)subProcessSetHeightOfTextViewDynamically
{
    
    CGSize sizeThatFitsTextView = [self.sendMessageTextView sizeThatFits:CGSizeMake(self.sendMessageTextView.frame.size.width, self.sendMessageTextView.frame.size.height)];
    self.textViewHeightConstraint.constant =  sizeThatFitsTextView.height;
    
    self.textMessageViewHeightConstaint.constant = (self.typingMessageView.frame.size.height-self.sendMessageTextView.frame.size.height) + sizeThatFitsTextView.height + paddingForTextMessageViewHeight;
}

-(void) scrollTableViewToBottomWithAnimation:(BOOL) animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.mTableView.contentSize.height > self.mTableView.frame.size.height) {
            CGPoint offset = CGPointMake(0, self.mTableView.contentSize.height - self.mTableView.frame.size.height);
            [self.mTableView setContentOffset:offset animated:animated];
        }
    });
}


//------------------------------------------------------------------------------------------------------------------
#pragma mark - Textfield Delegates
//------------------------------------------------------------------------------------------------------------------

#pragma mark tap gesture

- (IBAction)handleTap:(UITapGestureRecognizer *)sender {
    if ([self.sendMessageTextView isFirstResponder]) {
        [self.sendMessageTextView resignFirstResponder];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)sendAction:(id)sender
{
    NSCharacterSet *charsToTrim = [NSCharacterSet characterSetWithCharactersInString:@"  \n\""];
    self.sendMessageTextView.text = [self.sendMessageTextView.text stringByTrimmingCharactersInSet:charsToTrim];
  
    if(self.sendMessageTextView.text.length > 0)
    {
        [self postMessage];
    }
    
    [self.view layoutIfNeeded];
    [self setHeightOfTextViewDynamically];
}

- (IBAction)attachmentActionMethod:(id)sender {
    [self attachmentAction];
}

// SET CUSTOM BUTTON FOR CALL

-(UIView *)customCallButtonView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage: [ALUtilityClass getImageFromFramworkBundle:@"PhoneIcon.png"]];
    [imageView setFrame:CGRectMake(0, 0, 20, 20)];
    [imageView setTintColor:[UIColor whiteColor]];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    view.bounds = CGRectMake(view.bounds.origin.x, view.bounds.origin.y, view.bounds.size.width, view.bounds.size.height);
    [view addSubview:imageView];
    [view setBackgroundColor:[UIColor clearColor]];
    
    UITapGestureRecognizer * phoneIconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneCallMethod)];
    phoneIconTap.numberOfTapsRequired = 1;
    [view addGestureRecognizer:phoneIconTap];
    
    return view;
}

-(UIView *)customCloseButtonView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage: [ALUtilityClass getImageFromFramworkBundle:@"ic_clear_white.png"]];
    [imageView setFrame:CGRectMake(0, 0, 20, 20)];
    [imageView setTintColor:[UIColor whiteColor]];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    view.bounds = CGRectMake(view.bounds.origin.x, view.bounds.origin.y, view.bounds.size.width, view.bounds.size.height);
    [view addSubview:imageView];
    [view setBackgroundColor:[UIColor clearColor]];
    
    UITapGestureRecognizer * iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeConversation)];
    iconTap.numberOfTapsRequired = 1;
    [view addGestureRecognizer:iconTap];
    
    return view;
}


-(void)phoneCallMethod {

}

-(void)closeConversation {
    
}

-(UIView *)setCustomBackButton
{
    UIImage * backImage = [ALUtilityClass getImageFromFramworkBundle:@"bbb.png"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:backImage];
    [imageView setFrame:CGRectMake(-10, 0, 30, 30)];
    [imageView setTintColor:[ALApplozicSettings getColorForNavigationItem]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width - 5,
                                                               imageView.frame.origin.y + 5 , 20, 15)];
    
    [label setTextColor:[ALApplozicSettings getColorForNavigationItem]];
    [label setText:[ALApplozicSettings getTitleForBackButtonChatVC]];
    [label sizeToFit];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width + label.frame.size.width, imageView.frame.size.height)];
    view.bounds = CGRectMake(view.bounds.origin.x + 8, view.bounds.origin.y - 1, view.bounds.size.width, view.bounds.size.height);
    if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
        view.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        label.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    }
    [view addSubview:imageView];
    [view addSubview:label];
    
//    UIButton *button=[[UIButton alloc] initWithFrame:view.frame];
//    [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:button];
    
    UITapGestureRecognizer * backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    backTap.numberOfTapsRequired = 1;
    [view addGestureRecognizer:backTap];

    return view;
}   


@end
