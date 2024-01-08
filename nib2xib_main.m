#import <AppKit/AppKit.h>
#import "NIBParser.h"

int main(int argc, const char *argv[]) 
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  // If we have more than one argument, assume it is the nib file...
  if (argc > 1)
  {
    NSString *nibName = [NSString stringWithCString: argv[1]];
    NIBParser *parser = [[NIBParser alloc] initWithNibNamed: nibName];
    NSDictionary *dict = [parser parse];

    NSLog(@"--- Output");
    NSLog(@"parser = %@", parser);
    NSLog(@"dict = %@", dict);
  }

  [pool release];

  return 0;
}
