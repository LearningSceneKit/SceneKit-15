//
//  ViewController.m
//  SceneKit-15 力
//
//  Created by ShiWen on 2017/7/19.
//  Copyright © 2017年 ShiWen. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>

@interface ViewController ()
@property (nonatomic,strong)SCNView *mScnView;
@property (nonatomic,strong)SCNNode *cameraNode;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mScnView];
    
//    创建地板
    SCNNode *floorNode = [SCNNode nodeWithGeometry:[SCNFloor floor]];
    floorNode.geometry.firstMaterial.diffuse.contents = @"floor.jpg";
    floorNode.physicsBody = [SCNPhysicsBody staticBody];
    floorNode.position = SCNVector3Make(0, -10, 0);
    [self.mScnView.scene.rootNode addChildNode:floorNode];
    
    
//   小圆柱 创建圆柱
    SCNTube *tubSmall = [SCNTube tubeWithInnerRadius:1 outerRadius:2 height:6];
    tubSmall.firstMaterial.diffuse.contents = @"box2.jpg";
    SCNNode *tubSmallNode = [SCNNode nodeWithGeometry:tubSmall];
    tubSmallNode.physicsBody = [SCNPhysicsBody kinematicBody];
    tubSmallNode.position = SCNVector3Make(-5, -7, 0);
    [self.mScnView.scene.rootNode addChildNode:tubSmallNode];
    
    SCNTube *tubeBig = [SCNTube tubeWithInnerRadius:4 outerRadius:4.5 height:2];
    SCNNode *nodeTubeBig = [SCNNode nodeWithGeometry:tubeBig];
    tubeBig.firstMaterial.diffuse.contents = @"box2.jpg";
    nodeTubeBig.physicsBody = [SCNPhysicsBody kinematicBody];
    nodeTubeBig.position  = SCNVector3Make(5, -9, 0);
    [self.mScnView.scene.rootNode addChildNode:nodeTubeBig];
    
//    创建离子系统
    SCNParticleSystem *particleSystem = [SCNParticleSystem particleSystemNamed:@"fire.scnp" inDirectory:nil];
    SCNNode *particleSystemNode = [SCNNode node];
//    是否受物理力场影响
    particleSystem.affectedByPhysicsFields = YES;
//    使离子带上电荷，电荷量决定了粒子所受的引力或者斥力的影响
    particleSystem.particleCharge = -10;
    [particleSystemNode addParticleSystem:particleSystem];
    particleSystemNode.position = SCNVector3Make(0, 0, 0);
//    给小圆柱添加离子系统
    [tubSmallNode addChildNode:particleSystemNode];
    
    
//    添加电场力
    [nodeTubeBig addChildNode:[self addElectricFieldWithNode]];
//    添加旋转力
//    [tubSmallNode addChildNode:[self addVortexField]];
//    添加向心力
//    [tubSmallNode addChildNode:[self addRadialGravity]];
//    添加线性力
//    [tubSmallNode addChildNode:[self addLineGravity]];
//    添加随机力
//    [tubSmallNode addChildNode:[self addNoiseField]];
//    添加一个和速度成正比的随机力
//    [tubSmallNode addChildNode:[self addTurbulenceField]];
//    添加一个弹力
//    [self.mScnView.scene.rootNode addChildNode:[self addSpringField]];
//    添加磁场力
//    [tubSmallNode addChildNode:[self addMangneticField]];
    


    
}
//电场力
-(SCNNode *)addElectricFieldWithNode{
    SCNNode *electricFieldNode = [SCNNode node];
//    电场力
    electricFieldNode.physicsField = [SCNPhysicsField electricField];
//    力的大小、引力或者是斥力由粒子所带电荷的正负决定，和物理的引力斥力概念相同
    electricFieldNode.physicsField.strength = 10;
    return electricFieldNode;

    
}


//旋转力
-(SCNNode*)addVortexField{
    SCNNode *vortexFieldNode = [SCNNode node];
    vortexFieldNode.physicsField = [SCNPhysicsField vortexField];
//    力的大小
    vortexFieldNode.physicsField.strength = 10;
//    以哪个轴旋转 旋转方向由力的正负和轴的正负共同决定
    vortexFieldNode.physicsField.direction = SCNVector3Make(0, 0, 1);
    return vortexFieldNode;
}
//向心力
-(SCNNode*)addRadialGravity{
    SCNNode *radialgravityNode = [SCNNode node];
    radialgravityNode.physicsField = [SCNPhysicsField radialGravityField];
//    向心力方向，正为向心，负为离心
    radialgravityNode.physicsField.strength = -100;
    return radialgravityNode;
}

//线性力
-(SCNNode *)addLineGravity{
    SCNNode *lineGravityNode = [SCNNode node];
    lineGravityNode.physicsField = [SCNPhysicsField linearGravityField];
    lineGravityNode.physicsField.strength = 10;
//    力的方向  由坐标点和力的正负决定
    lineGravityNode.physicsField.direction = SCNVector3Make(1, 1, 1);
    return lineGravityNode;
}

///添加随机力
-(SCNNode *)addNoiseField{
    SCNNode *noiseFieldNode = [SCNNode node];
    noiseFieldNode.physicsField = [SCNPhysicsField noiseFieldWithSmoothness:0 animationSpeed:0];
    noiseFieldNode.physicsField.strength = 100;
    return noiseFieldNode;
}
//创建一个和速度成正比的随机力
-(SCNNode *)addTurbulenceField{
    SCNNode *turbulenceFieldNode = [SCNNode node];
    turbulenceFieldNode.physicsField = [SCNPhysicsField turbulenceFieldWithSmoothness:0 animationSpeed:1];
    turbulenceFieldNode.physicsField.strength = 10;
    return turbulenceFieldNode;
}

//添加一个弹力 胡克定律力 - 与距离中心距离成正比的力 这个的对象
//  场将以与质量的倒数成比例的周期振荡。
-(SCNNode *)addSpringField{
    SCNNode *springField = [SCNNode node];
    springField.physicsField = [SCNPhysicsField springField];
    springField.physicsField.strength = 0.1;
    springField.position = SCNVector3Make(0, 0, 10);
    return springField;
}
//磁场力
-(SCNNode *)addMangneticField{
    SCNNode *magneticFieldNode = [SCNNode node];
    magneticFieldNode.physicsField = [SCNPhysicsField magneticField];
    magneticFieldNode.physicsField.strength = -10;
    magneticFieldNode.physicsField.direction = SCNVector3Make(0, 0, 1);
    return magneticFieldNode;
}
-(SCNView *)mScnView{
    if (!_mScnView) {
        _mScnView = [[SCNView alloc] initWithFrame:self.view.bounds];
        _mScnView.backgroundColor = [UIColor blackColor];
        _mScnView.allowsCameraControl = YES;
        _mScnView.scene = [SCNScene scene];
        [_mScnView.scene.rootNode addChildNode:self.cameraNode];
    }
    return _mScnView;
}
//相机
-(SCNNode*)cameraNode{
    if (!_cameraNode) {
        _cameraNode= [SCNNode node];
        _cameraNode.camera = [SCNCamera camera];
        _cameraNode.position = SCNVector3Make(0, 0, 30);
        _cameraNode.rotation = SCNVector4Make(1, 0, 0, -M_PI_4/2);
        _cameraNode.camera.automaticallyAdjustsZRange = YES;
        [self.mScnView.scene.rootNode addChildNode:_cameraNode];
    }
    return _cameraNode;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
