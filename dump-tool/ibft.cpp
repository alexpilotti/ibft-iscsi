#include <Windows.h>
#include <cstdio>
#include "ibft.h"

int get_ibft_data(FILE* dumpfile, bool show_enum){
    int enumBufferSize = EnumSystemFirmwareTables('ACPI', NULL, 0);
    if (enumBufferSize == 0)return GetLastError();

    byte* enumBuffer = new byte[enumBufferSize];
    EnumSystemFirmwareTables('ACPI', enumBuffer, enumBufferSize);

    if (show_enum){
        printf("Fireware tables enum:\n");
        for (int i = 0; i < enumBufferSize; i += 4){
            for (int j = 0; j < 4; j++){
                printf("%c", enumBuffer[i + j]);
            }
            printf("\n");
        }
        printf("\n");
    }

    int ibftBufferSize = GetSystemFirmwareTable('ACPI', 'TFBi', 0, 0);
    if (ibftBufferSize == 0)return GetLastError();

    byte* ibftBuffer = new byte[ibftBufferSize];
    GetSystemFirmwareTable('ACPI', 'TFBi', ibftBuffer, ibftBufferSize);

    //fprintf(dumpfile, "iBFT table raw contents:\nStarts with [[[ ends with ]]]\n");
    //fprintf(dumpfile, "[[[");
    for (int i = 0; i < ibftBufferSize; i++){
        fprintf(dumpfile, "%c", ibftBuffer[i]);
    }
    //fprintf(dumpfile, "]]]\n");
    return 0;
}

WORD extensions_offset;
WORD initiator_offset;
WORD NIC0_offset;
WORD target0_offset;
WORD NIC1_offset;
WORD target1_offset;
void print_structure_type(char type);
void print_header(char* ibft);
void print_string(char* str, int len, char* caption);
void print_control(char* ibft);
void print_extension(char* ibft, int offset);
void print_initiator(char* ibft, int offset);
void print_ip_address(char* ip, char* caption);
void print_NIC(char* ibft, int offset, int name);
void print_ip_mask(int mask, char* caption);
void print_mac_address(char* mac, char* caption);
void print_PCI(WORD pci);
void print_target(char* ibft, int offset, int name);
void pretty_print_file(char* filename){
    FILE* dumpfile;
    fopen_s(&dumpfile, filename, "r");

    int filesize;
    fseek(dumpfile, 0, SEEK_END);
    filesize = ftell(dumpfile);

    char* file = new char[filesize];

    fseek(dumpfile, 0, SEEK_SET);
    fread(file, sizeof(char), filesize, dumpfile);
    fclose(dumpfile);

    printf("---iBFT header---\n");
    print_header(file);
    printf("---Control structure---\n");
    print_control(&file[48]);
    
    printf("---Extension structure---\n");
    print_extension(file, extensions_offset);
    printf("---Initiator structure---\n");
    print_initiator(file, initiator_offset);
    printf("---NIC0 structure---\n");
    print_NIC(file, NIC0_offset, 0);
    printf("---Target0 structure---\n");
    print_target(file, target0_offset, 0);
    printf("---NIC1 structure---\n");
    print_NIC(file, NIC1_offset, 1);
    printf("---Target1 structure---\n");
    print_target(file, target1_offset, 0);
}

void print_header(char* ibft){
    print_string(&ibft[0], 4, "Signature:");
    printf("Revision:%i\n", ibft[8]);
    printf("Checksum:%i\n", ibft[9]);
    print_string(&ibft[10], 6, "OEMID:");
    print_string(&ibft[16], 8, "OEM Table ID:");
    printf("\n");
}

void print_control(char* ibft){
    print_structure_type(ibft[0]);
    printf("Structure Version:%i\n", ibft[1]);
    printf("Index:%i\n", ibft[4]);
    printf("Boot failover flag:%i\n", ibft[5] & 1);
    printf("See ACPI 3.0b spec...3.4 control structure\n");

    extensions_offset = *(WORD*)&ibft[6];
    initiator_offset = *(WORD*)&ibft[8];
    NIC0_offset = *(WORD*)&ibft[10];
    target0_offset = *(WORD*)&ibft[12];
    NIC1_offset = *(WORD*)&ibft[14];
    target1_offset = *(WORD*)&ibft[16];
    printf("\n");
}

void print_string(char* str, int len, char* caption){
    printf("%s", caption);
    if (len == 0)printf(" not found");
    for (int i = 0; i < len; i++)
        printf("%c", str[i]);
    printf("\n");
}

void print_structure_type(char type){
    printf("Structure type:");
    if (type == 0)printf("Reserved");
    if (type == 1)printf("Control");
    if (type == 2)printf("Initiator");
    if (type == 3)printf("NIC");
    if (type == 4)printf("Target");
    if (type == 5)printf("Extensions");
    printf("\n");
}

void print_extension(char* ibft, int offset){
    if (offset == 0){
        printf("No extension\n\n");
        return;
    }
    printf("\n");
}
void print_initiator(char* ibft_chunk, int offset){
    if (offset == 0){
        printf("No initiator\n\n");
        return;
    }
    char* ibft = &ibft_chunk[offset];
    print_structure_type(ibft[0]);
    printf("Structure Version:%i\n", ibft[1]);
    printf("Lenght:%i (should be 74)\n", *(WORD*)&ibft[2]);
    printf("Index:%i\n", ibft[4]);
    printf("Block valid:%s\n", ((ibft[5] & 1) == 1) ? "yes" : "no");
    printf("Firmware boot selected:%s\n", ((ibft[5] & 2) == 2) ? "yes" : "no");
    print_ip_address(&ibft[6], "iSNS Server:");
    print_ip_address(&ibft[22], "SLP Server:");
    print_ip_address(&ibft[38], "Primary Radius Server:");
    print_ip_address(&ibft[54], "Secondary Server:");
    WORD name_length = *(WORD*)&ibft[70];
    WORD name_offset = *(WORD*)&ibft[72];
    print_string(&ibft_chunk[name_offset], name_length, "Initiator name:");
    printf("\n");
}

void print_ip_address(char* ip, char* caption){
    printf("%s", caption);
    bool is_ip = false;
    for (int i = 0; i < 16; i++)
        if (ip[i] != 0)is_ip = true;
    if (!is_ip){
        printf("No address\n");
        return;
    }
    int is_ipv6 = true;
    int leading_zeros = 0;
    for (int i = 0; i < 10; i++)
        if (ip[i] == 0)leading_zeros++;
    if (leading_zeros == 10 && (ip[10] & 0xff) == 0xff && (ip[11] & 0xff) == 0xff)
        is_ipv6 = false;
    if (is_ipv6){
        printf("IPv6 ");
        for (int i = 0; i < 4; i++){
            if(i)printf(":");
            for (int j = 0; j < 4; j++)
                printf("%02x", ip[i * 4 + j] & 0xff);
        }
        printf("\n");
    }
    else{
        printf("IPv4 ");
        for (int i = 0; i < 4; i++){
            if (i)printf(".");
            printf("%i", ip[i + 12]);
        }
        printf("\n");
    }
}

void print_NIC(char* ibft_chunk, int offset, int name){
    if (offset == 0){
        printf("No NIC%i structure\n", name);
        return;
    }
    char* ibft = &ibft_chunk[offset];

    print_structure_type(ibft[0]);
    printf("Structure Version:%i\n", ibft[1]);
    printf("Lenght:%i (should be 102)\n", *(WORD*)&ibft[2]);
    printf("Index:%i\n", ibft[4]);
    printf("Block valid:%s\n", ((ibft[5] & 1) == 1) ? "yes" : "no");
    printf("Firmware boot selected:%s\n", ((ibft[5] & 2) == 2) ? "yes" : "no");
    printf("Link %s\n", ((ibft[5] & 4) == 4) ? "local" : "global");
    print_ip_address(&ibft[6], "IP address:");
    print_ip_mask(ibft[22], "Subnet Mask Prefix:");
    print_ip_address(&ibft[24], "Gateway:");
    print_ip_address(&ibft[40], "Primary DNS:");
    print_ip_address(&ibft[56], "Secondary DNS:");
    print_ip_address(&ibft[72], "DHCP:");
    printf("VLAN:%u\n", *(WORD*)&ibft[88]);
    print_mac_address(&ibft[90], "MAC address:");
    print_PCI(*(WORD*)&ibft[96]);
    WORD name_length = *(WORD*)&ibft[70];
    WORD name_offset = *(WORD*)&ibft[72];
    print_string(&ibft_chunk[name_offset], name_length, "Host name:");
    printf("\n");
}

void print_ip_mask(int mask_length, char* caption){
    printf("%i<<<\n", mask_length);
    DWORD mask = 0;
    for (int i = 0; i < mask_length; i++)
        mask ^= 1 << (31-i);
    char* mask_array = (char*)&mask;
    printf("%s", caption);
    for (int i = 0; i < 4; i++)
        printf(".%u", mask_array[3-i]&0xff);
    printf("\n");
}

void print_mac_address(char* mac, char* caption){
    printf("%s", caption);
    for (int i = 0; i < 6; i++){
        if (i)printf("-");
        printf("%x", mac[i]&0xff);
    }
    printf("\n");
}

void print_PCI(WORD pci){
    printf("PCI:%04x\n", pci);
    printf("Bus/Dev/Func: ");
    printf("%i/", (pci >> 8) & 0xff);
    printf("%i/", (pci >> 3) & 0x1f);
    printf("%i\n",  (pci >> 0) & 0x07);
}

void print_target(char* ibft_chunk, int offset, int name){
    if (offset == 0){
        printf("No NIC%i structure\n", name);
        return;
    }
    char* ibft = &ibft_chunk[offset];
    printf("Structure Version:%i\n", ibft[1]);
    printf("Lenght:%i (should be 54)\n", *(WORD*)&ibft[2]);
    printf("Index:%i\n", ibft[4]);
    printf("Block valid:%s\n", ((ibft[5] & 1) == 1) ? "yes" : "no");
    printf("Firmware boot selected:%s\n", ((ibft[5] & 2) == 2) ? "yes" : "no");
    printf("Use Radius CHAP %s\n", ((ibft[5] & 4) == 4) ? "yes" : "no");
    printf("Use Radius rCHAP %s\n", ((ibft[5] & 8) == 8) ? "yes" : "no");
    print_ip_address(&ibft[6], "Target IP Address:");
    printf("Target IP socket:%i\n", *(WORD*)&ibft[22]);
    printf("Target boot LUN:%04x%04x\n", *(DWORD*)&ibft[24],*(DWORD*)&ibft[28]);

    char chap_type = ibft[32];
    printf("CHAP type:");
    if (chap_type == 0)printf("No CHAP\n");
    if (chap_type == 1)printf("CHAP\n");
    if (chap_type == 2)printf("Mutual CHAP\n");

    printf("NIC index:%i\n", ibft[33]);

    print_string(&ibft_chunk[*(WORD*)&ibft[36]], *(WORD*)&ibft[34] & 0xffff, "Target name:");
    printf("CHAP - The name/password the Initiator sends to the Target\n");
    printf("reverse CHAP - The name/password the Target sends to the Initiator\n");
    print_string(&ibft_chunk[*(WORD*)&ibft[40]], *(WORD*)&ibft[38] & 0xffff, "CHAP name:");
    print_string(&ibft_chunk[*(WORD*)&ibft[44]], *(WORD*)&ibft[42] & 0xffff, "CHAP secret:");
    print_string(&ibft_chunk[*(WORD*)&ibft[48]], *(WORD*)&ibft[46] & 0xffff, "Reverse CHAP name:");
    print_string(&ibft_chunk[*(WORD*)&ibft[52]], *(WORD*)&ibft[50] & 0xffff, "Reverse CHAP secret:");
}