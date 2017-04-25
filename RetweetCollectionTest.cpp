#include "RetweetCollection.h"
#include <gmock/gmock.h>

using namespace ::testing;

class ARetweetCollection : public Test
{
public:
	RetweetCollection collection;
	
};

TEST_F(ARetweetCollection, IsEmptyWhenCreated)
{
	ASSERT_TRUE(collection.isEmpty());
}

TEST_F(ARetweetCollection, HasSizeZeroWhenCreated)
{
	ASSERT_THAT(collection.size(), Eq(0u));
}
