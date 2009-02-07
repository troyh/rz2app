
struct LOGININFO
{
	char userid[64];
	char email[64];
	char password[64];
	char secret[64];
	
	LOGININFO();
};

LOGININFO* lookupLogin(const char* email);
void getDomain(char* buffer,size_t bufsize);
bool createLogin(const char* email, const char* password, const char* userid, const char* secret);
void setLoginCookies(LOGININFO* login);
void clearLoginCookies();



