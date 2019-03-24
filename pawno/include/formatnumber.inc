stock FormatNumber(numbers, chars[] = " ")
{
	new temp[24],counter = -1;
	valstr(temp,numbers);
	
	for(new i = strlen(temp);i > 0; i--)
	{
		counter++;
		if(counter == 3)
		{
			strins(temp,chars,i);
			counter = 0;
		}
	}
	return temp;
}