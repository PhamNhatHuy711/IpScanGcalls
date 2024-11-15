#!/bin/bash

bash_encode() {
  esc=${1@Q}
  echo "${esc:2:-1}"
}

echo "Nhap duong dan csv"
read csv_file

# Kiểm tra xem file csv có tồn tại không
if [[ ! -f "$csv_file" ]]; then
  echo "File nhập vào không tồn tại."
  exit 1
fi

# Tạo file CSV kết quả và thêm tiêu đề cho các cột
echo "IP,File,Line,Type,Project" > result.csv

while IFS=, read -r ip; do
  if [[ -n "$ip" ]]; then
    encoded_ip=$(bash_encode "$ip")
    echo "Dang tim kiem IP: $encoded_ip"
    
    # Tìm kiếm và lưu kết quả bao gồm dòng, file và loại file
    grep -r -H -n -o "$encoded_ip" --include="*" . | while read -r line; do
      # Lấy tên file và số dòng
      filename=$(echo "$line" | cut -d: -f1)
      lineno=$(echo "$line" | cut -d: -f2)
      
      # Lấy loại file dưới dạng MIME-type
      file_type=$(file --mime-type -b "$filename")

      # Lấy tên thư mục gốc ngay sau dấu `./`
      project_dir=$(echo "$filename" | sed -E 's|^\./([^/]+).*|\1|')

      # Ghi vào result.csv với định dạng CSV
      echo "$ip,$filename,$lineno,$file_type,$project_dir" >> result.csv
    done
  fi
done < "$csv_file"

echo "Quá trình tìm kiếm hoàn tất, kết quả được lưu vào result.csv"

