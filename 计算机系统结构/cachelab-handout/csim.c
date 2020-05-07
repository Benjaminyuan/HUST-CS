#include "cachelab.h"
#include <fcntl.h>
#include<stdlib.h>
#include <stdio.h>
#include <getopt.h>
#include <string.h>
#define MAX_SIZE 100
typedef struct arguments
{
    int h;
    int v;
    int s; // 组数的位数
    int E; //关联度
    int b; //块的位数
    char t[100];
    /* data */
} Arguments;

typedef struct cache_line
{
    int valid_bit; //有效位
    int tag_bit;   //标志位
    int times;     // 访问次数
} CacheLine;
typedef struct trace
{
    char opt;
    long address;
    int size;
} Trace;
typedef struct cache_res
{
    int hit;
    int miss;
    int evict;
} CacheRes;
typedef CacheLine* CacheGroup;
typedef CacheGroup* Cache;
typedef Trace *Traces;
void parse_param(int argc, char *argv[], Arguments *args)
{
    int opt;
    while ((opt = getopt(argc, argv, "hvs:E:b:t:")) != -1)
    {
        switch (opt)
        {
        case 'h':
            args->h = 1;
            break;
        case 'v':
            args->v = 1;
            break;
        case 's':
            args->s = atoi(optarg);
            break;
        case 'E':
            args->E = atoi(optarg);
            break;
        case 'b':
            args->b = atoi(optarg);
            break;
        case 't':
            strcpy(args->t, optarg);
            break;
        default:
            printf("invalid arguments");
            exit(0);
            break;
        }
    }
}

Cache init_cache(Arguments *args)
{
    printf("init cached\n");

    int lines = args->E; //关联度
    int group_nums = 1 << args->s;
    printf("args: s:%d,t: %s,E: %d\n",args->s,args->t,args->E);

    Cache cache = (CacheGroup *)malloc(sizeof(CacheGroup) * group_nums);
    for (int i = 0; i < group_nums; i++)
    {
        // 每组分配lines个缓存行的内存
        cache[i] = (CacheLine *)malloc(sizeof(CacheLine) * lines);
        for (int j = 0; j < lines; j++)
        {
            //初始化
            cache[i][j].tag_bit = -1;
            cache[i][j].valid_bit = 0;
            cache[i][j].times = 0;
        }
    }
    return cache;
}
void get_cached(CacheRes *r, Cache cache, Arguments *args, long address)
{
    long mask = 0xffffffffffffffff >> (64 - args->s);
    address >>= args->b;
    //组号
    int index = mask & address;
    // 标识位
    int tag = address >> args->s;
    int E = args->E;
    CacheGroup group = cache[index];
    //缓存命中
    //累加器实现LRU，times最大的说明在组内被访问的次数最少；
    for (int i = 0; i < E; i++)
    {
        if (group[i].valid_bit == 1)
        {
            group[i].times++;
        }
    }
    for (int i = 0; i < E; i++)
    {
        if (group[i].valid_bit == 1 && group[i].tag_bit == tag)
        {
            group[i].times = 0;
            r->hit++;
            return;
        }
    }
    r->miss++;
    //查找有无空行
    for (int i = 0; i < E; i++)
    {
        if (group[i].valid_bit == 0)
        {
            group[i].valid_bit = 1;
            group[i].tag_bit = tag;
            return;
        }
    }
    //如果没有空行，就利用LRU替换
    r->evict++;
    int max_times = group[0].times, max_index = 0;
    for (int i = 1; i < E; i++)
    {
        if (group[i].times > max_times)
        {
            max_index = i;
            max_times = group[i].times;
        }
    }
    group[max_index].tag_bit = tag;
    group[max_index].times = 0;
}
void parse_tracse(Cache cache, Arguments *arg, CacheRes *r)
{
    FILE *fp = fopen(arg->t, "rt");
    char opt;
    long address;
    int size = -1;
    while (fscanf(fp, "%c %lx,%d\n", &opt, &address, &size) != EOF)
    {
        if (size == -1)
        {
            continue;
        }
        if(arg->v == 1){
            printf("opt: %c,addr: %lx\n",opt,address);
        }
        switch (opt)
        {
        case 'I':
            break;
        case 'L':
            get_cached(r, cache, arg, address);
            break;
        case 'M':
            get_cached(r, cache, arg, address);
            get_cached(r, cache, arg, address);
            break;
        case 'S':
            get_cached(r, cache, arg, address);
            break;
        default:
            break;
        }
    }
    fclose(fp);
}

int main(int argc, char *argv[])
{

    Arguments args = {0};


    CacheRes cache_res = {0,0,0};
    parse_param(argc, argv, &args);
    printf("args: s:%d,t:%s",args.s,args.t);
    Cache cache = init_cache(&args);
    parse_tracse(cache, &args, &cache_res);
    printSummary(cache_res.hit, cache_res.miss, cache_res.evict);
    return 0;
}
