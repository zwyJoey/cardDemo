//
//  MBTwitterScroll.m
//  TwitterScroll
//
//  Created by Martin Blampied on 07/02/2015.
//  Copyright (c) 2015 MartinBlampied. All rights reserved.
//
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height

#import "MBTwitterScroll.h"
#import "UIScrollView+TwitterCover.h"
#import "Note.h"



CGFloat const offset_HeaderStop = 40.0;
CGFloat const offset_B_LabelHeader = 95.0;
CGFloat const distance_W_LabelHeader = 35.0;


@implementation MBTwitterScroll

- (MBTwitterScroll *)initScrollViewWithBackgound:(UIImage*)backgroundImage avatarImage:(UIImage *)avatarImage Person:(Person *)person buttonTitle:(NSString *)buttonTitle contentHeight:(CGFloat)height {
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self = [[MBTwitterScroll alloc] initWithFrame:bounds];
    [self setupView:backgroundImage avatarImage:avatarImage Person:(Person *)person buttonTitle:buttonTitle scrollHeight:height type:MBScroll];
    
    return self;
}


- (MBTwitterScroll *)initTableViewWithBackgound:(UIImage*)backgroundImage avatarImage:(UIImage *)avatarImage Person:(Person *)person buttonTitle:(NSString *)buttonTitle {
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self = [[MBTwitterScroll alloc] initWithFrame:bounds];
    
    [self setupView:backgroundImage avatarImage:avatarImage Person:(Person *)person buttonTitle:buttonTitle scrollHeight:0 type:MBTable];
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    return self;
    
}



- (void) setupView:(UIImage*)backgroundImage avatarImage:(UIImage *)avatarImage Person:(Person *)person buttonTitle:(NSString *)buttonTitle scrollHeight:(CGFloat)height type:(MBType)type {
    self.person = person;
    
    // Header
    self.header = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 107)];
    [self addSubview:self.header];
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.header.frame.size.height - 5, self.frame.size.width, 25)];
    self.headerLabel.textAlignment = NSTextAlignmentCenter;
    self.headerLabel.text = person.name;
    self.headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    self.headerLabel.textColor = [UIColor whiteColor];
    [self.header addSubview:self.headerLabel];
    
    if (type == MBTable) {
        // TableView
        self.tableView = [[UITableView alloc] initWithFrame:self.frame];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.showsVerticalScrollIndicator = NO;
        
        // TableView Header
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.header.frame.size.height + 100)];
        [self addSubview:self.tableView];
        
    } else {
        
        // Scroll
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        CGSize newSize = CGSizeMake(self.frame.size.width, height);
        self.scrollView.contentSize = newSize;
        self.scrollView.delegate = self;
    }
    
    
    self.avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 79, 69, 69)];
    self.avatarImage.image = avatarImage;
    self.avatarImage.layer.cornerRadius = 10;
    self.avatarImage.layer.borderWidth = 3;
    self.avatarImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarImage.clipsToBounds = YES;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 156, 250, 25)];
    self.titleLabel.text = person.name;
    
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 177, 250, 25)];
    self.subtitleLabel.text = person.post;
    self.subtitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
    self.subtitleLabel.textColor = [UIColor lightGrayColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 220, WIDTH-20, 1000-250)];
    
    
    
    if (buttonTitle.length > 0) {
        self.headerButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, 120, 80, 35)];
        [self.headerButton setTitle:buttonTitle forState:UIControlStateNormal];
        [self.headerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.headerButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
        self.headerButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.headerButton.layer.borderWidth = 1;
        self.headerButton.layer.cornerRadius = 8;
        [self.headerButton addTarget:self action:@selector(recievedMBTwitterScrollButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (type == MBTable) {
        [self.tableView addSubview:self.avatarImage];
        [self.tableView addSubview:self.titleLabel];
        [self.tableView addSubview:self.subtitleLabel];
        if (buttonTitle.length > 0) {
            [self.tableView addSubview:self.headerButton];
        }
    } else {
        [self.scrollView addSubview:self.avatarImage];
        [self.scrollView addSubview:self.titleLabel];
        [self.scrollView addSubview:self.subtitleLabel];
        [self.scrollView addSubview:view];
        if (buttonTitle.length > 0) {
            [self.scrollView addSubview:self.headerButton];
        }
    }
    
    //往view上添加东西
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10,(WIDTH-40)/7*5, 20)];
    [view addSubview:label];
    label.text = @"电话";
    [label setTextColor:[UIColor colorWithRed:0.545 green:0.855 blue:0.965 alpha:1.00]];
    UILabel *teleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 34, (WIDTH-40)/7*5, 20)];
    [view addSubview:teleLabel];
    teleLabel.text = person.tele;
    //按钮一
    UIButton *call = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH-40)/7*5+10, 10, (WIDTH-40)/7*2, 40)];
    [call setTitle:@"电话" forState:UIControlStateNormal];
    [call setTitleColor:[UIColor colorWithRed:0.545 green:0.855 blue:0.965 alpha:1.00] forState:UIControlStateNormal];
    [view addSubview:call];
    [call addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
    //一条线
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(10, 60, WIDTH-40, 2)];
    line1.backgroundColor = [UIColor colorWithRed:0.965 green:0.965 blue:0.965 alpha:1.00];
    [view addSubview:line1];
    //备注
    UILabel *labelNote = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, WIDTH-40, 20)];
    labelNote.text = @"备注";
    [view addSubview:labelNote];
    [labelNote setTextColor:[UIColor colorWithRed:0.545 green:0.855 blue:0.965 alpha:1.00]];
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, WIDTH-40, 50)];
    [view addSubview:self.textView];
    // 设置预设文本
    self.textView.text = @"";
    // 设置文本字体
    self.textView.font = [UIFont fontWithName:@"Arial" size:16.5f];
    // 设置文本颜色
    self.textView.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];
    // 设置文本框背景颜色
    self.textView.backgroundColor = [UIColor colorWithRed:254/255.0f green:254/255.0f blue:254/255.0f alpha:1.0f];
    // 设置文本对齐方式
    self.textView.textAlignment = NSTextAlignmentLeft;
    
    self.textView.delegate = self;//设置它的委托方法
    self.textView.returnKeyType
    = UIReturnKeyDefault;//返回键的类型
    
    self.textView.keyboardType
    = UIKeyboardTypeDefault;//键盘类型
    
    self.textView.scrollEnabled
    = YES;//是否可以拖动
    
    self.textView.editable
    =YES;
    
    self.textView.autoresizingMask
    = UIViewAutoresizingFlexibleHeight;//自适应高度
    //定义一个toolBar
    UIToolbar
    * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    //设置style
    [topView
     setBarStyle:UIBarStyleBlack];
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    UIBarButtonItem
    * button1 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem
    * button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //定义完成按钮
    UIBarButtonItem
    * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成"style:UIBarButtonItemStyleDone
                                                  target:self action:@selector(resignKeyboard)];
    //在toolBar上加上这些按钮
    NSArray
    * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    [topView setItems:buttonsArray];
    
    [self.textView setInputAccessoryView:topView];
    //一条线2
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(10, self.textView.frame.size.height+self.textView.frame.origin.y+10, WIDTH-40, 2)];
    line2.backgroundColor = [UIColor colorWithRed:0.965 green:0.965 blue:0.965 alpha:1.00];
    [view addSubview:line2];
    //公司 公司地址
    if ([person.company length]>0) {
        UILabel *companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, line2.frame.size.height+line2.frame.origin.y+10,(WIDTH-40)/7*5, 20)];
        [view addSubview:companyLabel];
        companyLabel.text = @"公司";
        
        [companyLabel setTextColor:[UIColor colorWithRed:0.545 green:0.855 blue:0.965 alpha:1.00]];
        UILabel *companyAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, companyLabel.frame.size.height+companyLabel.frame.origin.y+4, (WIDTH-40)/7*5, 20)];
        [view addSubview:companyAddressLabel];
        companyAddressLabel.text = person.company;
        
    }
    
    
    self.headerImageView = [[UIImageView alloc] initWithFrame:self.header.frame];
    self.headerImageView.image = backgroundImage;
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.header insertSubview:self.headerImageView aboveSubview:self.headerLabel];
    self.header.clipsToBounds = YES;
    
    self.avatarImage.layer.cornerRadius = 10;
    self.avatarImage.layer.borderWidth = 3;
    self.avatarImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.blurImages = [[NSMutableArray alloc] init];
    
    if (backgroundImage != nil) {
        [self prepareForBlurImages];
    } else {
        self.headerImageView.backgroundColor = [UIColor blackColor];
    }
    
}
-(void)resignKeyboard
{
    
    [self.textView
     resignFirstResponder];
    if (self.textView.text.length == 0) {
        self.textView.text = @"";
        //如果文本框内是原本的提示文字，则显示灰色字体
        [self.textView setTextColor:[UIColor lightGrayColor]];
    }else{
        //保存
        [self addNote:self.textView.text Person:self.person];
    }
    
}//添加备注的方法
-(void)addNote:(NSString *)str Person:(Person *)person{
    //通过UIApplication的代理获得上下文
    UIApplication *application  = [UIApplication sharedApplication];
    id delelgate = application.delegate;
    self.managedObjectContext = [delelgate managedObjectContext];
    //设置代理
    self.frc.delegate = self;
    
    //创建一个备注
    Note *newNote;
    if (!newNote) {
        newNote = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Note class]) inManagedObjectContext:self.managedObjectContext];
    }
    //赋值
    NSDate *date = [NSDate date];
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setDateFormat:@"yyyy/MM/dd HH:mm"];
    [df2 setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *strNote = [df2 stringFromDate:date];
    
    newNote.date = strNote;
    newNote.message = str;
    newNote.person = person;
    //通过上下文保存数据
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"2 === %@",[error localizedFailureReason]);
    }
    
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self.textView resignFirstResponder];
//}
////textView的回调方法
//- (void)textDidEndEditing:(NSNotification *)notification {
//    if (self.textView.text.length == 0) {
//        self.textView.text = @"";
//        //如果文本框内是原本的提示文字，则显示灰色字体
//        [self.textView setTextColor:[UIColor lightGrayColor]];
//    }else{
//        //保存
//        [self.note addNote:self.textView.text];
//    }
//}

//打电话的方法
-(void)call:(Person *)person{
    NSLog(@"拨打电话按钮");
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.person.tele]];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    [self animationForScroll:offset];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CGFloat offset = self.tableView.contentOffset.y;
    [self animationForScroll:offset];
}


- (void) animationForScroll:(CGFloat) offset {
    
    CATransform3D headerTransform = CATransform3DIdentity;
    CATransform3D avatarTransform = CATransform3DIdentity;
    
    // DOWN -----------------
    
    if (offset < 0) {
        
        CGFloat headerScaleFactor = -(offset) / self.header.bounds.size.height;
        CGFloat headerSizevariation = ((self.header.bounds.size.height * (1.0 + headerScaleFactor)) - self.header.bounds.size.height)/2.0;
        headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0);
        headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0);
        
        self.header.layer.transform = headerTransform;
        
        if (offset < -self.frame.size.height/3.5) {
            [self recievedMBTwitterScrollEvent];
        }
        
    }
    
    // SCROLL UP/DOWN ------------
    
    else {
        
        // Header -----------
        headerTransform = CATransform3DTranslate(headerTransform, 0, MAX(-offset_HeaderStop, -offset), 0);
        
        //  ------------ Label
        CATransform3D labelTransform = CATransform3DMakeTranslation(0, MAX(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0);
        self.headerLabel.layer.transform = labelTransform;
        self.headerLabel.layer.zPosition = 2;
        
        // Avatar -----------
        CGFloat avatarScaleFactor = (MIN(offset_HeaderStop, offset)) / self.avatarImage.bounds.size.height / 1.4; // Slow down the animation
        CGFloat avatarSizeVariation = ((self.avatarImage.bounds.size.height * (1.0 + avatarScaleFactor)) - self.avatarImage.bounds.size.height) / 2.0;
        avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0);
        avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0);
        
        if (offset <= offset_HeaderStop) {
            
            if (self.avatarImage.layer.zPosition <= self.headerImageView.layer.zPosition) {
                self.header.layer.zPosition = 0;
            }
            
        }else {
            if (self.avatarImage.layer.zPosition >= self.headerImageView.layer.zPosition) {
                self.header.layer.zPosition = 2;
            }
        }
        
    }
    if (self.headerImageView.image != nil) {
        [self blurWithOffset:offset];
    }
    self.header.layer.transform = headerTransform;
    self.avatarImage.layer.transform = avatarTransform;
    
    
}



- (void)prepareForBlurImages
{
    CGFloat factor = 0.1;
    [self.blurImages addObject:self.headerImageView.image];
    for (NSUInteger i = 0; i < self.headerImageView.frame.size.height/10; i++) {
        [self.blurImages addObject:[self.headerImageView.image boxblurImageWithBlur:factor]];
        factor+=0.04;
    }
}



- (void) blurWithOffset:(float)offset {
    NSInteger index = offset / 10;
    if (index < 0) {
        index = 0;
    }
    else if(index >= self.blurImages.count) {
        index = self.blurImages.count - 1;
    }
    UIImage *image = self.blurImages[index];
    if (self.headerImageView.image != image) {
        [self.headerImageView setImage:image];
    }
}



- (void) recievedMBTwitterScrollButtonClicked {
    [self.delegate recievedMBTwitterScrollButtonClicked];
}



- (void) recievedMBTwitterScrollEvent {
    [self.delegate recievedMBTwitterScrollEvent];
}


// Function to blur the header image (used if the header image is replaced with updateHeaderImage)
-(void)resetBlurImages {
    [self.blurImages removeAllObjects];
    [self prepareForBlurImages];
}


// Function to update the header image and blur it out appropriately
-(void)updateHeaderImage:(UIImage*)newImage {
    self.headerImageView.image = newImage;
    [self resetBlurImages];
}

@end
