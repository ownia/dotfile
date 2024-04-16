# Test the Devicetree bindings
make dt_binding_check

make dt_binding_check DT_SCHEMA_FILES=trivial-devices.yaml
make dt_binding_check DT_SCHEMA_FILES=qcom
make dt_binding_check DT_SCHEMA_FILES=/gpio/

# Test the DTS files
export CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64
make defconfig

make dtbs_check
make CHECK_DTBS=y qcom/sm8450-hdk.dtb
make CHECK_DTBS=y DT_SCHEMA_FILES=trivial-devices.yaml qcom/sm8450-hdk.dtb
make CHECK_DTBS=y DT_SCHEMA_FILES=/gpio/ qcom/sm8650.dtb
make CHECK_DTBS=y DT_SCHEMA_FILES=qcom qcom/sm8450-hdk.dtb
