print_array(){
	for i in $1 ; do
                echo File from folder $2: $i
        done
	echo
}

remove_file(){
	$(cd $1; rm $2)
}

check_file(){
	for i in $1 ; do
		if [ "$i" == "$2" ]
		then
			main_file=$(cd $3; stat -c%Y $i)
			compare_file=$(cd $4; stat -c%Y $i)

			if (($main_file >= $compare_file))
			then
				remove_file $3 $i
			fi		
		fi
				
        done
}
	
main()
{
	echo

	main_directory_files=$(cd $1; ls *)
	additional_directory_files=$(cd $2; ls *)

        for i in $main_directory_files ; do
               check_file "${additional_directory_files[@]}" $i $1 $2 
        done
}

clean_test(){
	echo
	echo Clean after prev test ...
	echo --------------------------------------------------- 
	echo

	$(rm -rf test_main_folder1);
	$(rm -rf test_add_folder1);

	$(rm -rf test_main_folder2);
        $(rm -rf test_add_folder2);

	$(rm -rf test_main_folder3);
        $(rm -rf test_add_folder3);
}

test1(){
	echo Test 1 is running ..

	main_folder="test_main_folder1";
	add_folder="test_add_folder1";

	$(mkdir $main_folder)
	$(mkdir $add_folder)

	$(cd $main_folder; touch file1.txt);
	$(cd $main_folder; touch file2.txt);
	$(cd $main_folder; touch file3.txt);

	$(cd $main_folder; cp file1.txt "../$add_folder");
	$(cd $main_folder; cp file2.txt "../$add_folder");
	$(cd $main_folder; cp file3.txt "../$add_folder");

	main $main_folder $add_folder
	count=$(cd $main_folder; ls -1 | wc -l)
	
	if [ $count -ne 0 ]
	then
		echo "Test failed!"
	else
		echo "Test succeeded!"
	fi
	
	echo ---------------------------------------------------
	echo
}

test2(){
	echo Test 2 is running ..

	main_folder="test_main_folder2";
        add_folder="test_add_folder2";

        $(mkdir $main_folder)
        $(mkdir $add_folder)

        $(cd $main_folder; touch file1.txt);
        $(cd $main_folder; touch file2.txt);
        $(cd $main_folder; touch file3.txt);
	$(cd $main_folder; touch file4.txt);

        $(cd $main_folder; cp file1.txt "../$add_folder");
        $(cd $main_folder; cp file2.txt "../$add_folder");
        $(cd $main_folder; cp file3.txt "../$add_folder");
	
	sleep 1

	$(cd $add_folder; echo "Modified" > file1.txt);
	$(cd $add_folder; echo "Modified" > file2.txt);
	$(cd $add_folder; echo "Modified" > file3.txt);

        main $main_folder $add_folder 
        count=$(cd $main_folder; ls -1 | wc -l)

        if [ $count -ne 4 ]
        then
                echo "Test failed!"
        else
                echo "Test succeeded!"
        fi

	echo ---------------------------------------------------
        echo
}

test3(){
        echo Test 3 is running ..

        main_folder="test_main_folder3";
        add_folder="test_add_folder3";

        $(mkdir $main_folder)
        $(mkdir $add_folder)

        $(cd $main_folder; touch file1.txt);
        $(cd $main_folder; touch file2.txt);
        $(cd $main_folder; touch file3.txt);
        $(cd $main_folder; touch file4.txt);

        $(cd $main_folder; cp file1.txt "../$add_folder");
        $(cd $main_folder; cp file2.txt "../$add_folder");
        
	sleep 1

        $(cd $add_folder; touch file3.txt);
                
        main $main_folder $add_folder
        count=$(cd $main_folder; ls -1 | wc -l)


        if [ $count -ne 2 ]
        then
                echo "Test failed!"
        else
                echo "Test succeeded!"
        fi

        echo ---------------------------------------------------
        echo

}

if [ -z "$1" ]
then
	clean_test
	test1
	test2
	test3
elif [ $1 !=  "--help" ]
then
	echo Entered argument is not valid. 
	echo Please, check --help to find out the problem
elif [ $1 == "--help"  ]
then
	echo
	echo This is infromation about the script bash_script.sh
	echo
	echo This script contains one method main that compares two directoriesfiles and remove from the first directory files that have the same filename butwas modified earlier. Also script contains three test that are running automaticaly. If you want to run the script, write the next command:
	echo
	echo -e '\t' bash bash_script.sh "[--help]" 
	echo -e '\t' "->" help is paramater that will inform you about script
fi
