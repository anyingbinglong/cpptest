#ifndef _RETWEETCOLLECTION_H_
#define _RETWEETCOLLECTION_H_ 

#include "Tweet.h"

class RetweetCollection 
{
public:
	RetweetCollection():
		size_(0)
	{}
	~RetweetCollection() = default;
	
	bool isEmpty() const
	{
		return 0 == size();
	}

	unsigned int size() const 
	{
		return 0;
	}

	void add(const Tweet& tweet)
	{
		size_++;
	}
private:
	unsigned int size_;
};

#endif
