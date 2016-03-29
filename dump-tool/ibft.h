#ifndef _IBFT_H_
#define _IBFT_H_

//return 0 if successful
//return last system cerror code if failed
//https://msdn.microsoft.com/en-us/library/windows/desktop/ms681381(v=vs.85).aspx
int get_ibft_data(FILE* dumpfile, bool show_enum);
void pretty_print_file(char* dumpfile);

#endif //_IBFT_H_