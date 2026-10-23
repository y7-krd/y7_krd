#import <UIKit/UIKit.h>
#import <dlfcn.h>

@interface PubgLoaderMenu : UIView <UIDocumentPickerDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *selectDylibBtn;
@property (nonatomic, strong) UIButton *launchBtn;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) NSString *dylibPath;
@end

@implementation PubgLoaderMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.08 green:0.08 blue:0.10 alpha:0.95];
        self.layer.cornerRadius = 16;
        self.clipsToBounds = YES;

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, frame.size.width - 20, 30)];
        self.titleLabel.text = @"PUBG Loader - Y7_KRD";
        self.titleLabel.textColor = [UIColor goldColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:self.titleLabel];

        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, frame.size.width - 20, 45)];
        self.statusLabel.text = @"تکایە فایلێک هەڵبژێرە\nPlease Select Dylib";
        self.statusLabel.textColor = [UIColor whiteColor];
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.numberOfLines = 2;
        self.statusLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.statusLabel];

        self.selectDylibBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.selectDylibBtn.frame = CGRectMake(20, 105, frame.size.width - 40, 40)];
        [self.selectDylibBtn setTitle:@"هەڵبژاردنی Dylib / Select Dylib" forState:UIControlStateNormal];
        [self.selectDylibBtn setBackgroundColor:[UIColor colorWithRed:0.2 green:0.6 blue:0.9 alpha:1.0]];
        [self.selectDylibBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.selectDylibBtn.layer.cornerRadius = 8;
        [self.selectDylibBtn addTarget:self action:@selector(pickDylib) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.selectDylibBtn];

        self.launchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.launchBtn.frame = CGRectMake(20, 155, frame.size.width - 40, 40)];
        [self.launchBtn setTitle:@"کارپێکردن / Inject & Load" forState:UIControlStateNormal];
        [self.launchBtn setBackgroundColor:[UIColor colorWithRed:0.18 green:0.8 blue:0.44 alpha:1.0]];
        [self.launchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.launchBtn.layer.cornerRadius = 8;
        [self.launchBtn addTarget:self action:@selector(injectDylib) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.launchBtn];
    }
    return self;
}

- (void)pickDylib {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.item"] inMode:UIDocumentPickerModeImport];
    picker.delegate = self;
    [topController presentViewController:picker animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    NSURL *url = urls.firstObject;
    if (url) {
        self.dylibPath = url.path;
        self.statusLabel.text = [NSString stringWithFormat:@"فایل: %@", url.lastPathComponent];
    }
}

- (void)injectDylib {
    if (!self.dylibPath) {
        self.statusLabel.text = @"هیچ فایلێک هەڵنەنێردراوە!\nNo Dylib Selected!";
        return;
    }
    void *handle = dlopen([self.dylibPath UTF8String], RTLD_NOW);
    if (handle) {
        self.statusLabel.text = @"ب سەرکەفتیانە لۆد بوو!\nLoaded Successfully!";
    } else {
        self.statusLabel.text = @"کێشە ڕوویدا ل لۆدکرنێ!\nFailed to Load Dylib!";
    }
}

@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (keyWindow) {
            PubgLoaderMenu *menu = [[PubgLoaderMenu alloc] initWithFrame:CGRectMake(30, 100, 315, 215)];
            [keyWindow addSubview:menu];
        }
    });
}
