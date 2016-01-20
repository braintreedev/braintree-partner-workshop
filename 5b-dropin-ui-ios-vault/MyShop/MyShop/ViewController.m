//
//  ViewController.m
//  MyShop
//
//  Created by Kartakis, George on 1/19/16.
//  Copyright © 2016 Kartakis, George. All rights reserved.
//

#import "ViewController.h"
#import "BraintreeUI.h"


@interface ViewController () <BTDropInViewControllerDelegate>

@property (nonatomic, strong) BTAPIClient *braintreeClient;
@property (nonatomic, strong) NSString *customerId;
@property (weak) IBOutlet UIButton *buyButton;

@end

@implementation ViewController


- (void)viewDidLoad
    {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createCustomer];
    }

- (void)didReceiveMemoryWarning
    {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    }

- (void) initBraintreeClient
    {
//    NSURL *clientTokenURL = [NSURL URLWithString:@"https://braintree-sample-merchant.herokuapp.com/client_token"];
    NSURL *clientTokenURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:8888/braintreeclienttoken.php?customerid=%@", self.customerId]];
    NSMutableURLRequest *clientTokenRequest = [NSMutableURLRequest requestWithURL:clientTokenURL];
    [clientTokenRequest setValue:@"text/plain" forHTTPHeaderField:@"Accept"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:clientTokenRequest completionHandler:^(NSData * _Nullable data,NSURLResponse * _Nullable response, NSError * _Nullable error)
        {
        // TODO: Handle errors
        NSString *clientToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"clientToken = %@", clientToken);
        self.braintreeClient = [[BTAPIClient alloc] initWithAuthorization:clientToken];
        // As an example, you may wish to present our Drop-in UI at this point.
        // Continue to the next section to learn more...
        }] resume];
    self.buyButton.alpha = 1.00f;
    }

- (void) createCustomer
    {
    NSURL *createCustomerURL = [NSURL URLWithString:@"http://localhost:8888/braintreecreateclient.php"];
    NSMutableURLRequest *customerIdRequest = [NSMutableURLRequest requestWithURL:createCustomerURL];
    [customerIdRequest setValue:@"text/plain" forHTTPHeaderField:@"Accept"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:customerIdRequest completionHandler:^(NSData * _Nullable data,NSURLResponse * _Nullable response, NSError * _Nullable error)
        {
        self.customerId = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          
        NSLog(@"customerId = %@", self.customerId);
        [self initBraintreeClient];
        }] resume];
    }

// With this example, you should ensure that your users cannot tap the pay button until
// the client token has been obtained from your server and has been used to create a
// Braintree instance.

- (IBAction)tappedBuyButton
    {
    // If you haven't already, create and retain a `BTAPIClient` instance with a tokenization
    // key or a client token from your server.
    // Typically, you only need to do this once per session.
    //self.braintreeClient = [[BTAPIClient alloc] initWithAuthorization:aClientToken];
    
    // Create a BTDropInViewController
    BTDropInViewController *dropInViewController = [[BTDropInViewController alloc]
                                                    initWithAPIClient:self.braintreeClient];
    dropInViewController.delegate = self;
    
    // This is where you might want to customize your view controller (see below)
    
    // The way you present your BTDropInViewController instance is up to you.
    // In this example, we wrap it in a new, modally-presented navigation controller:
    UIBarButtonItem *item = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                             target:self
                             action:@selector(userDidCancelPayment)];
    dropInViewController.navigationItem.leftBarButtonItem = item;
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:dropInViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
    }

- (void)userDidCancelPayment
    {
    [self dismissViewControllerAnimated:YES completion:nil];
    }

// Implement BTDropInViewControllerDelegate

- (void)dropInViewController:(BTDropInViewController *)viewController didSucceedWithTokenization:(BTPaymentMethodNonce *)paymentMethodNonce
    {
    // Send payment method nonce to your server for processing
    [self postNonceToServer:paymentMethodNonce.nonce];
    [self dismissViewControllerAnimated:YES completion:nil];
    }

- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController
    {
    [self dismissViewControllerAnimated:YES completion:nil];
    }

- (void)postNonceToServer:(NSString *)paymentMethodNonce
    {
    // Update URL with your server
//    NSDictionary* valuesToPostWithKeys = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:paymentMethodNonce,self.customerId,nil] forKeys:[NSArray arrayWithObjects:@"payment_method_nonce",@"customerid",nil]];
    NSURL *paymentURL = [NSURL URLWithString:@"http://localhost:8888/braintreepaywithcustomerid.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:paymentURL];
    request.HTTPBody = [[NSString stringWithFormat:@"payment_method_nonce=%@&customerid=%@", paymentMethodNonce, self.customerId] dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    //NSLog(@"request = %@", request);
        
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
        {
        NSLog(@"data = %@", data);
        NSLog(@"response = %@", response);
        NSLog(@"error = %@", error);
        }] resume];
    }

@end
