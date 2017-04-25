#ifndef _RETWEETCOLLECTION_H_
#define _RETWEETCOLLECTION_H_ 

class RetweetCollection 
{
public:
	RetweetCollection() = default;
	~RetweetCollection() = default;
	
	bool isEmpty() const
	{
		return 0 == size();
	}

	unsigned int size() const 
	{
		return 0;
	}
};

#endif
