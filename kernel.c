/* This will force us to create a kernel entry function instead of jumping to kernel.c:0x00 */
#define COLOR 0x8c

void clear_screen() // clear the entire text screen
{
	char *vga = (char *)0xb8000;
	unsigned int i = 0;
	while (i < (80 * 25 * 2))
	{
		vga[i] = ' ';
		i++;
		vga[i] = COLOR;
		i++;
	}
}

unsigned int printf(char *message, unsigned int line) // the message and then the line #
{
	char *vga = (char *)0xb8000;
	unsigned int i = 0;

	i = (line * 80 * 2);

	while (*message != 0)
	{
		if (*message == '\n') 
		{
			line++;
			i = (line * 80 * 2);
			*message++;
		}
		else
		{
			vga[i] = *message;
			*message++;
			i++;
			vga[i] = COLOR;
			i++;
		}
	}

	return (1);
}

void main() // like main in a normal C program
{
	clear_screen();
	printf("Hi!\n This is our Kernel\n", 0);
	printf("Our Team Members:   \n", 1);
	printf("1. Aditya Garg \n", 2);
	printf("2. Ayush Agarwal\n", 3);
	printf("3. Anup Aglawe \n", 4);
	printf("4. Anshuman yadav \n", 5);
	printf("5. Ujjaval shah \n", 6);
};



// void main() {
//     char* video_memory = (char*) 0xb8000;
//     *video_memory = 'X';
// }