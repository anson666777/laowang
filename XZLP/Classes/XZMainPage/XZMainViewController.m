//
//  XZMainViewController.m
//  XZLP
//
//  Created by anson on 2020/9/14.
//  Copyright © 2020 anson. All rights reserved.
//

#import "XZMainViewController.h"
#import "Macros.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry/Masonry.h>
#import "XZMainTableViewCell.h"
#import "XZDetailViewController.h"
#import "CWCarousel.h"
#import "CWPageControl.h"
#import "XMGenerQRCodeViewController.h"
#import "XZScanViewController.h"
#define kViewTag 666
#define kCount 0

@interface XZMainViewController ()<CWCarouselDatasource, CWCarouselDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) AVCaptureDevice * device;

@property (nonatomic, strong) AVCaptureDeviceInput * input;

@property (nonatomic, strong) AVCaptureMetadataOutput * output;

@property (nonatomic, assign) BOOL isOn;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *scanBtn_1;

@property (nonatomic, strong) NSMutableArray *titleArr;

@property (nonatomic, strong) NSMutableArray *pics;

@property (nonatomic, strong) NSMutableArray *contentArray;

@property (nonatomic, strong) CWCarousel *carousel;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation XZMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"旅拍西藏";
    self.view.backgroundColor = MainColor;
    [self setupSubViews];
    [self createDisplay];
    [self setupButtons];
    [self tableView];
}

- (void)setupSubViews {
    [self setupNavi];
    [self setupDevice];
}

- (void)setupNavi {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 60);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn setImage:[UIImage imageNamed:@"lighticon_btn"] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = rightBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)setupDevice {
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
}

- (void)createDisplay{

//    NSURL *url = [NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
//    self.playerItem = [[AVPlayerItem alloc] initWithURL:url];
//    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
//    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
//    self.playerLayer.frame = CGRectMake(0, 0, WindowWidth, 250);
//    self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
//    [self.view.layer addSublayer:self.playerLayer];
//    [self.player play];
    
    CWFlowLayout *flowLayout = [[CWFlowLayout alloc] initWithStyle:CWCarouselStyle_H_2];
    CWCarousel *carousel = [[CWCarousel alloc] initWithFrame:CGRectZero
                                                    delegate:self
                                                  datasource:self
                                                  flowLayout:flowLayout];
    carousel.isAuto = YES;
    carousel.autoTimInterval = 5;
    carousel.endless = YES;
    carousel.aligment = UICollectionViewScrollPositionLeft;
    carousel.backgroundColor = MainColor;
    [carousel registerViewClass:[UICollectionViewCell class] identifier:@"cellId"];
    [self.view addSubview:carousel];
    
    [carousel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_offset(250);
    }];
    
    self.carousel = carousel;
    [self.carousel freshCarousel];
}

- (void)setupButtons {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"把对西藏想说的话生成二维码" forState:UIControlStateNormal];
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 3;
    [button addTarget:self action:@selector(clickGener:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(25);
        make.right.equalTo(self.view).offset(-25);
        make.height.mas_offset(45);
        make.top.equalTo(self.view).offset(280);
    }];
    
    UIButton *button_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_1 setTitle:@"扫二维码看看小伙伴对西藏说的话" forState:UIControlStateNormal];
    [button_1 addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
    button_1.layer.borderColor = [UIColor whiteColor].CGColor;
    button_1.layer.borderWidth = 3;
    [self.view addSubview:button_1];
    
    self.scanBtn_1 = button_1;
    
    [button_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(25);
        make.right.equalTo(self.view).offset(-25);
        make.height.mas_offset(45);
        make.top.equalTo(button.mas_bottom).offset(15);
    }];
}

- (void)rightButtonAction:(UIButton *)sender {
    if (self.isOn) {
        [_device lockForConfiguration:nil];
        [_device setTorchMode:AVCaptureTorchModeOff];
        [_device unlockForConfiguration];
    }else {
        [_device lockForConfiguration:nil];
        [_device setTorchMode:AVCaptureTorchModeOn];
        [_device unlockForConfiguration];
    }
    
    self.isOn = !self.isOn;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scanBtn_1.mas_bottom).offset(15);
            make.left.right.bottom.equalTo(self.view).offset(0);
        }];
    }
    
    return _tableView;
}

#pragma mark -- UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[XZMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.imgName = self.pics[indexPath.row];
    cell.title = self.titleArr[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XZDetailViewController *vc = [[XZDetailViewController alloc] init];
    vc.index = indexPath.row;
    vc.picName = self.pics[indexPath.row];
    vc.content = self.contentArray[indexPath.row];
    vc.title = self.titleArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"布达拉宫",@"纳木措",@"念青唐古拉山",@"八廓街 ",@"羊卓雍措"].mutableCopy;
    }
    return _titleArr;
}

- (NSMutableArray *)pics {
    if (!_pics) {
        _pics = @[@"01",@"05",@"06",@"07",@"08"].mutableCopy;
    }
    return _pics;
}

- (NSMutableArray *)contentArray {
    if (!_contentArray) {
        _contentArray = @[@"布达拉宫（藏文：པོ་ཏ་ལ），坐落于中国西藏自治区的首府拉萨市区西北玛布日山上，是世界上海拔最高，集宫殿、城堡和寺院于一体的宏伟建筑，也是西藏最庞大、最完整的古代宫堡建筑群。布达拉宫依山垒砌，群楼重叠，是藏式古建筑的杰出代表（据说源于桑珠孜宗堡），中华民族古建筑的精华之作，是第五套人民币50元纸币背面的风景图案 [1]  。主体建筑分为白宫和红宫两部分。主楼高117米 [2]  ，外观13层，内为9层。布达拉宫前辟有布达拉宫广场，是世界上海拔最高的城市广场。布达拉宫最初为吐蕃王朝赞普松赞干布为迎娶尺尊公主和文成公主而兴建。1645年（清顺治二年）清朝属国和硕特汗国时期护法王固始汗和格鲁派摄政者索南群培重建布达拉宫之后，成为历代达赖喇嘛冬宫居所，以及重大宗教和政治仪式举办地，也是供奉历世达赖喇嘛灵塔之地，旧时与驻藏大臣衙门共为统治中心。1988—1994年再次大规模修缮。布达拉宫是藏传佛教（格鲁派）的圣地，每年至此的朝圣者及旅游观光客不计其数。1961年3月，国务院列其为首批全国重点文物保护单位；1994年12月，联合国教科文组织列其为世界文化遗产；2013年1月，国家旅游局又列其为国家AAAAA级旅游景区。2018年11月1日起至2019年3月15日，布达拉宫实行免费参观",@"纳木错，位于西藏自治区中部，是西藏第二大湖泊，也是中国第三大的咸水湖。湖面海拔4718米，形状近似长方形，东西长70多千米，南北宽30多千米，面积约1920km²。早期的科学考察认为，纳木错的最大深度为33米，但最近两年对湖泊的重新测量发现，纳木错最深处超过了120米。蓄水量768亿立方米，为世界上海拔最高的大型湖泊。纳木错”为藏语，蒙古语名称为“腾格里海”，都是“天湖”之意。纳木错是西藏的“三大圣湖”之一。 纳木措是古象雄佛法雍仲本教的第一神湖，为著名的佛教圣地之一。",@"念青唐古拉山脉 [1]  （Nyainqêntanglha Shanmai）属于断块山，位于中国西藏自治区。横贯西藏中东部，为冈底斯山向东的延续，东南延伸与横断山脉西南部的伯舒拉岭相接，中部略为向北凸出，同时将西藏划分成藏北、藏南、藏东南三大区域。东南靠近雅鲁藏布江大拐弯处的南迦巴瓦峰。据雍仲苯教资料所言：念青唐拉是藏地三大神山（冈底斯、念青唐拉、玛积雪山）之一，也是九大神山之一，更是十三大神山之首。 传说纳木错与念青唐拉曾经是一对恩爱夫妻。而根据雍仲苯教护法经、家族史以及神山祭祀文等苯教典籍记载：唐拉是雍仲本教的神山之一，是母子护法的四大眷属之龙度唐拉，也是古藏文化史记中较有影响力的著名神山。而纳木措为雍仲本教五骑羊护法母子的圣地，也是唐拉神山的明妃。它与纳木措是修行之人的主要修行圣地。念青唐古拉山地区受东西向的怒江断裂带和雅鲁藏布江断裂带的控制，挤压断裂褶皱是形成了海拔平均6000米以上的高大山系，它的山脊线位于当雄—羊八井以西，全长1400千米，平均宽80千米，海拔5000-6000米，主峰念青唐古拉峰海拔7111米，终年白雪皑皑。念青唐古拉山脉同时也是青藏高原东南部最大的冰川区。西段为内流区和外流区分界，东段为雅鲁藏布江和怒江分水岭。西北侧为藏北大湖区，其中最大的是纳木错湖。",@"在藏语中，“八廓”是“中转经道”的意思。八廓街引又名八角街，位于拉萨市旧城区，是拉萨著名的转经道和商业中心，较完整地保存了古城的传统面貌和居住方式。八廓街原街道只是单一围绕大昭寺的转经道，藏族人称为“圣路”。现逐渐扩展为围绕大昭寺周围的大片旧式老街区。八廓街是由八廓东街、八廓西街、八廓南街和八廓北街组成多边形街道环，周长约1000余米，街内岔道较多，有街巷35个。八廓街属城关区八廓街办事处，下辖4个居委会，199个居民大院。 ",@"羊卓雍措（YamdrokTso），有的人简称羊湖（并非藏北的羊湖），藏语意为“碧玉湖”，是西藏三大圣湖之一，像珊瑚枝一般，因此它在藏语中又被称为“上面的珊瑚湖”。主要位于西藏山南市浪卡子县，中段在浪卡子县与贡嘎县之间，拉萨西南约70公里处，与纳木错、玛旁雍错并称西藏三大圣湖，是喜马拉雅山北麓最大的内陆湖泊，湖光山色之美，冠绝藏南。羊卓雍措面积675km²，湖面海拔4,441米。从拉萨到羊湖需要翻越5030米的岗巴拉山口。2012年6月有报道称将建观光项目，山南市已责成浪卡子县立即停止该项目。其湖面平静，一片翠蓝，仿佛如山南高原上的蓝宝石 [1]  。"].mutableCopy;
    }
    return _contentArray;
}

#pragma mark - CWCarouselDatasource && CWCarouselDelegate
- (NSInteger)numbersForCarousel {
    return self.dataArr.count;
}

- (UICollectionViewCell *)viewForCarousel:(CWCarousel *)carousel indexPath:(NSIndexPath *)indexPath index:(NSInteger)index{
    UICollectionViewCell *cell = [carousel.carouselView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    UIImageView *imgView = [cell.contentView viewWithTag:kViewTag];
    if(!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, cell.bounds.size.width - 20, cell.bounds.size.height)];
        imgView.tag = kViewTag;
        imgView.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:imgView];
        cell.layer.masksToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
    }

    NSString *name = self.dataArr[index];
    UIImage *img = [UIImage imageNamed:name];
    if(!img) {
        NSLog(@"%@", name);
    }
    [imgView setImage:img];
    return cell;
}

- (void)CWCarousel:(CWCarousel *)carousel didSelectedAtIndex:(NSInteger)index {
    NSLog(@"...%ld...", (long)index);
}


- (void)CWCarousel:(CWCarousel *)carousel didStartScrollAtIndex:(NSInteger)index indexPathRow:(NSInteger)indexPathRow {
    NSLog(@"开始滑动: %ld", index);
}


- (void)CWCarousel:(CWCarousel *)carousel didEndScrollAtIndex:(NSInteger)index indexPathRow:(NSInteger)indexPathRow {
    NSLog(@"结束滑动: %ld", index);
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
        NSString *imgName = @"";
        for (int i = 0; i < 5; i++) {
            imgName = [NSString stringWithFormat:@"0%ld.jpg", i + 1];
            [_dataArr addObject:imgName];
        }
    }
    return _dataArr;
}

- (void)scan:(UIButton *)sender {
    XZScanViewController *vc = [XZScanViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickGener:(UIButton *)sender {
    XMGenerQRCodeViewController *vc = [XMGenerQRCodeViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
