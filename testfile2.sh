#!/bin/bash

bash_encode() {
  esc=${1@Q}
  echo "${esc:2:-1}"
}

echo "Nhap duong dan csv"
read csv_file
# Kiểm tra xem file public.csv có tồn tại không
if [[ ! -f "$csv_file" ]]; then
  echo "File Nhap vao không tồn tại."
  exit 1
fi

> result.txt

while IFS=, read -r ip; do
	 if [[ -n "$ip" ]]; then
		echo "Dang tim kiem IP : $(bash_encode $ip)"
		grep -r -H -n -o  $(bash_encode $ip) >> result.txt
	 fi
	done < "$csv_file"
echo " Qua Trinh tim kiem hoan tat,ket qua duoc luu vao result.txt"

