# 所有源文件和头文件都在同一个目录下
# 万用的Makefile====用于多文件，多目录的工程性C++语言项目构建
# 需要修改的地方，都用数字编号标识出来了（1）--->（5）

.PHONY: all clean

# 创建目录的命令
MKDIR = mkdir -p

# 生成目录的命令
RM = rm
RMFLAGS = -rf

# 指定编译器
CC = gcc
# （1）根据需要，修改编译选项，例如，项目中使用了pthread线程库，在此处增加-lpthread
# 此处可以自定义编译选项
CFLAGS = -W -Wall -ggdb3 -std=c++11

# 将编译生成的目标文件，可执行文件，依赖文件，都放到了build目录下
DIR_OBJS = build/objs
DIR_EXES = build/exes
DIR_DEPS = build/deps
DIRS = $(DIR_OBJS) $(DIR_EXES) $(DIR_DEPS) 

# （2）根据需要，修改此处。变量EXE中存放的是最终生成的可执行文件的名字。
EXE = list1 
EXE := $(addprefix $(DIR_EXES)/, $(EXE))

# （3）根据需要，修改此处
# 自定义源文件（.cpp）所在路径：在$(wildcard  ..... )的括号里添加你新增的源文件所在的目录
# 例如：在device目录下新建立了一个子目录src，并在该子目录下新增了一些源文件，
# 那么只需在下面这行代码的末尾，增加：device/src/*.cpp
SRCS = $(wildcard *.cpp)

# 去除SRCS变量中的路径信息，并将生成的目标文件.o放入到变量$(DIR_OBJS)/指定的目录中
temp1 = $(notdir $(SRCS))
OBJS = $(temp1:.cpp=.o)
OBJS := $(addprefix $(DIR_OBJS)/, $(OBJS))

# 去除SRCS变量中的路径信息，并将生成的依赖文件.dep放入到变量$(DIR_DEPS)/指定的目录中
temp2 = $(notdir $(SRCS))
DEPS = $(temp2:.cpp=.dep)
DEPS := $(addprefix $(DIR_DEPS)/, $(DEPS))

# 使Makefile文件不会发生死循环
ifeq ("$(wildcard $(DIR_DEPS))","")
DEP_DIR_DEPS := $(DIR_DEPS)
endif

# （4）根据需要，修改此处
# 自定义头文件（.h）所在路径：在这里添加你新增的头文件所在的目录。
# 例如：在lib目录下新建立了一个子目录inc，并在该子目录下新增了一些头文件，
# 那么只需在下面这行代码的末尾，增加：-I /lib/inc。
INC_DIRS = 

#（5）根据需要，修改此处
# 指定搜索源文件（.cpp）的路径
# 使用vpath，是为了要和生成目标文件的规则中的===》%.o : %.cpp配合，实现在不同目录下寻找源文件（.cpp）。
# 因为，%.o : %.cpp，中的 %.cpp，默认只在当前目录（Makefile文件所在的目录）中寻找源文件（.cpp）
# 例如：
# 1. 只有一处要搜索的源文件（.cpp）的路径
# vpath %.cpp 源文件（.cpp）所在路径
#
# 2. 有两处要搜索的源文件（.cpp）的路径
# vpath %.cpp 第一处源文件（.cpp）所在路径:第二处源文件（.cpp）所在路径
#
# 3. 有三处要搜索的源文件（.cpp）的路径
# vpath %.cpp 第一处源文件（.cpp）所在路径:第二处源文件（.cpp）所在路径
# vpath % 第三处源文件（.cpp）所在路径
#
# 4. 有四处及四处以上搜索的源文件（.cpp）的路径
# vpath %.cpp 第一处源文件（.cpp）所在路径
# vpath % 第二处源文件（.cpp）所在路径
# vpath % 第三处源文件（.cpp）所在路径
# vpath % 第四处源文件（.cpp）所在路径
# vpath % 第...处源文件（.cpp）所在路径
# ...................................
# vpath %.cpp 最后一处源文件（.cpp）所在的路径

all: $(EXE)

# 在Makefile中使用在build/deps目录中生成的依赖文件
-include $(DEPS)

# 创建目录
$(DIRS):
	@$(MKDIR) $@
# 生成可执行文件
$(EXE): $(DIR_EXES) $(OBJS)
	$(CC) -o $@ $(filter %.o, $^) $(CFLAGS)
# 生成目标文件
$(DIR_OBJS)/%.o: $(DIR_OBJS) %.cpp
	$(CC) $(INC_DIRS) $(CFLAGS) -o $@ -c $(filter %.cpp, $^)	
# 生成依赖文件
$(DIR_DEPS)/%.dep: $(DEP_DIR_DEPS) %.cpp
	@echo "Making $@..."
	@set -e;\
	$(RM) $(RMFLAGS) $@.tmp;\
	$(CC) $(INC_DIRS) -E -MM $(filter %.cpp, $^) > $@.tmp;\
	sed 's, \(.*\)\.o[ :]*, build/objs/\1.o $@: ,g' < $@.tmp > $@;\
	$(RM) $(RMFLAGS) $@.tmp

clean:
	$(RM) $(RMFLAGS) build
