-- LICENSE_NOT_REQ_REQUEST - PK - lic_sk_id
create
or replace table `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_license_not_req_request_vw_v1 AS
SELECT
    *
FROM
    (
        SELECT
            LICENSE_NOT_REQ_REQUEST.RQSTR_USERID AS rqstr_userid,
            LICENSE_NOT_REQ_REQUEST.APPV_USERID AS appv_userid,
            LICENSE_NOT_REQ_REQUEST.APPV_IND AS appv_ind,
            LICENSE_NOT_REQ_REQUEST.NOT_REQD_RSN_CD AS not_reqd_rsn_cd,
            LICENSE_NOT_REQ_REQUEST.LAST_CHNG_USERID AS last_chng_userid,
            LICENSE_NOT_REQ_REQUEST.LAST_CHNG_TS AS last_chng_ts,
            LICENSE_NOT_REQ_REQUEST.CNTRY_CD AS cntry_cd,
            GLM_LICENSE_DOCUMENT.LIC_SK_ID AS lic_sk_id,
            GLM_LICENSE_DOCUMENT.TASK_SK_ID AS task_sk_id,
            GLM_LICENSE_DOCUMENT.LIC_DOC_TYPE_CD AS lic_doc_type_cd,
            TRIM(LICENSE_NOT_REQ_RSN_TXT.NOT_REQD_RSN_DESC) AS not_reqd_rsn_desc,
            LICENSE_NOT_REQ_RSN_TXT.LANG_CD AS lang_cd,
            CASE
                WHEN ROW_NUMBER() OVER(
                    PARTITION BY GLM_LICENSE_DOCUMENT.LIC_SK_ID,
                    LICENSE_NOT_REQ_REQUEST.CNTRY_CD,
                    LICENSE_NOT_REQ_RSN_TXT.LANG_CD
                    ORDER BY
                        LICENSE_NOT_REQ_REQUEST.LAST_CHNG_TS DESC
                ) = 1 THEN 1
                ELSE 0
            END AS last_not_req_request_ind
        FROM
            `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_lic_not_reqd_rq LICENSE_NOT_REQ_REQUEST
            JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_glm_lic_doc GLM_LICENSE_DOCUMENT ON LICENSE_NOT_REQ_REQUEST.DOC_ID = GLM_LICENSE_DOCUMENT.DOC_ID
            AND LICENSE_NOT_REQ_REQUEST.CNTRY_CD = GLM_LICENSE_DOCUMENT.CNTRY_CD
            JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_lic_not_reqd_rsn_txt LICENSE_NOT_REQ_RSN_TXT ON LICENSE_NOT_REQ_REQUEST.NOT_REQD_RSN_CD = LICENSE_NOT_REQ_RSN_TXT.NOT_REQD_RSN_CD
            AND TRIM(COALESCE(LICENSE_NOT_REQ_REQUEST.CNTRY_CD, '')) = TRIM(COALESCE(LICENSE_NOT_REQ_RSN_TXT.CNTRY_CD, ''))
    ) LICENSE_NOT_REQ_REQUEST_VW
WHERE
    LAST_NOT_REQ_REQUEST_IND = 1
    AND APPV_IND = 1;

-- GLM_PROJECT_LICENSE
create
or replace table `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_project_license_vw_v1 AS
SELECT
    GLM_PROJECT_LICENSE.LIC_SK_ID AS lic_sk_id,
    GLM_PROJECT.PROJ_ID AS proj_id,
    GLM_PROJECT.FCLTY_NBR AS fclty_nbr,
    GLM_PROJECT.CPLT_IND AS cplt_ind,
    GLM_PROJECT.PROJ_STATUS_CD AS proj_status_cd,
    GLM_PROJECT.PROJ_TYPE_CD AS proj_type_cd,
    GLM_PROJECT.CNTRY_CD AS cntry_cd,
    GLM_PROJECT_TYPE_TXT.LANG_CD AS lang_cd,
    GLM_PROJECT_TYPE_TXT.PROJ_TYPE_DESC AS proj_type_desc
FROM
    `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.cmply_glm_proj_lic GLM_PROJECT_LICENSE
    JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.cmply_glm_proj GLM_PROJECT ON GLM_PROJECT_LICENSE.PROJ_ID = GLM_PROJECT.PROJ_ID
    AND GLM_PROJECT_LICENSE.CNTRY_CD = GLM_PROJECT.CNTRY_CD
    JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.cmply_glm_proj_type_txt GLM_PROJECT_TYPE_TXT ON GLM_PROJECT.PROJ_TYPE_CD = GLM_PROJECT_TYPE_TXT.PROJ_TYPE_CD
    AND GLM_PROJECT.CNTRY_CD = GLM_PROJECT_TYPE_TXT.CNTRY_CD;

-- GLM_LICENSE_NOTE
create
or replace table `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_license_note_vw_v1 AS
SELECT
    GLM_LICENSE_NOTE.LIC_SK_ID AS lic_sk_id,
    GLM_LICENSE_NOTE.TASK_SK_ID AS task_sk_id,
    GLM_LICENSE_NOTE.CNTRY_CD AS cntry_cd,
    GLM_LICENSE_NOTE.GLM_TASK_NOTE_TXT AS glm_task_note_txt
FROM
    (
        SELECT
            lic_sk_id,
            task_sk_id,
            cntry_cd,
            glm_task_note_txt,
            ROW_NUMBER() OVER(
                PARTITION BY lic_sk_id,
                task_sk_id,
                cntry_cd
                ORDER BY
                    LAST_CHNG_TS DESC
            ) as rownum
        FROM
            `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.cmply_glm_lic_note GLM_LICENSE_NOTE
    ) GLM_LICENSE_NOTE
WHERE
    rownum = 1;

-- GLM_PAYMENT_D_VW - PK - PYMT_NBR, GLM_TASK_ID, CNTRY_CD, LANG_CD, APPV_SEQ_NBR, PYMT_LINE_NBR
create
or replace table `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_payment_d_vw_v1 AS
SELECT
    GLM_PAYMENT.PYMT_NBR AS pymt_nbr,
    GLM_PAYMENT.GLM_TASK_ID AS glm_task_id,
    GLM_PAYMENT.VEND_NBR AS vend_nbr,
    GLM_PAYMENT.TOT_PYMT_AMT AS tot_pymt_amt,
    GLM_PAYMENT.GLM_PYMT_MTHD_CD AS glm_pymt_mthd_cd,
    GLM_PAYMENT.RQSTR_USER_ID AS rqstr_user_id,
    GLM_PAYMENT.SAP_INV_NBR AS sap_inv_nbr,
    GLM_PAYMENT.CRNCY_CD AS crncy_cd,
    GLM_PAYMENT.GLM_PYMT_STATUS_CD AS glm_pymt_status_cd,
    GLM_PAYMENT.PYMT_RCV_TS AS pymt_rcv_ts,
    GLM_PAYMENT.PYMT_CREATE_TS AS pymt_create_ts,
    GLM_PAYMENT.PYMT_DUE_TS AS pymt_due_ts,
    GLM_PAYMENT.GEN_LDGR_ACCT_NBR AS gen_ldgr_acct_nbr,
    GLM_PAYMENT.CHK_NBR AS chk_nbr,
    GLM_PAYMENT.MNY_ORDER_NBR AS mny_order_nbr,
    GLM_PAYMENT.VEND_NM AS vend_nm,
    GLM_PAYMENT.CNTRY_CD AS cntry_cd,
    GLM_PAYMENT_METHOD.SAP_PYMT_IND AS sap_pymt_ind,
    GLM_PAYMENT_METHOD.ACTV_IND AS pymt_mthd_actv_ind,
    GLM_PAYMENT_METHOD_TXT.LANG_CD AS lang_cd,
    TRIM(GLM_PAYMENT_METHOD_TXT.GLM_PYMT_MTHD_DESC) AS glm_pymt_mthd_desc,
    TRIM(GLM_PAYMENT_STATUS_TXT.GLM_PYMT_STATUS_DESC) AS glm_pymt_status_desc,
    GLM_PAYMENT_APPROVAL.APPV_SEQ_NBR AS appv_seq_nbr,
    GLM_PAYMENT_APPROVAL.GLM_APPVR_USER_ID AS glm_appvr_user_id,
    GLM_PAYMENT_APPROVAL.GLM_PYMT_APPV_STAT_CD AS glm_pymt_appv_stat_cd,
    GLM_PAYMENT_APPROVAL.REJECTION_IND AS rejection_ind,
    GLM_PAYMENT_APPROVAL.REJECTION_TXT AS rejection_txt,
    TRIM(GLM_PYMNT_APPV_STAT_TXT.GLM_PYMT_APPV_STAT_DESC) AS glm_pymt_appv_stat_desc,
    GLM_PAYMENT_LINE.PYMT_LINE_NBR AS pymt_line_nbr,
    GLM_PAYMENT_LINE.GLM_PYMT_TYPE_CD AS glm_pymt_type_cd,
    GLM_PAYMENT_LINE.FCLTY_NBR AS fclty_nbr,
    GLM_PAYMENT_LINE.GLM_APPLN_TYPE_CD AS glm_appln_type_cd,
    GLM_PAYMENT_LINE.GLM_LIC_CLASS_CD AS glm_lic_class_cd,
    GLM_PAYMENT_LINE.GLM_LIC_CATG_CD AS glm_lic_catg_cd,
    GLM_PAYMENT_LINE.LIC_TYPE_CD AS lic_type_cd,
    GLM_PAYMENT_LINE.MDSE_DIV_NBR AS mdse_div_nbr,
    GLM_PAYMENT_TYPE.ACTV_IND AS pymt_type_actv_ind,
    TRIM(GLM_PAYMENT_TYPE_TXT.GLM_PYMT_TYPE_DESC) AS glm_pymt_type_desc
FROM
    `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.cmply_glm_pymt GLM_PAYMENT
    JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.cmply_glm_pymt_mthd GLM_PAYMENT_METHOD ON GLM_PAYMENT.GLM_PYMT_MTHD_CD = GLM_PAYMENT_METHOD.GLM_PYMT_MTHD_CD
    AND GLM_PAYMENT.CNTRY_CD = GLM_PAYMENT_METHOD.CNTRY_CD
    JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.cmply_glm_pymt_mthd_txt GLM_PAYMENT_METHOD_TXT ON GLM_PAYMENT.GLM_PYMT_MTHD_CD = GLM_PAYMENT_METHOD_TXT.GLM_PYMT_MTHD_CD
    AND GLM_PAYMENT.CNTRY_CD = GLM_PAYMENT_METHOD_TXT.CNTRY_CD
    JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.cmply_glm_pymt_status_txt GLM_PAYMENT_STATUS_TXT ON GLM_PAYMENT.GLM_PYMT_STATUS_CD = GLM_PAYMENT_STATUS_TXT.GLM_PYMT_STATUS_CD
    AND GLM_PAYMENT.CNTRY_CD = GLM_PAYMENT_STATUS_TXT.CNTRY_CD
    AND GLM_PAYMENT_METHOD_TXT.LANG_CD = GLM_PAYMENT_STATUS_TXT.LANG_CD
    JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.cmply_glm_pymt_appv GLM_PAYMENT_APPROVAL ON GLM_PAYMENT.PYMT_NBR = GLM_PAYMENT_APPROVAL.PYMT_NBR
    AND GLM_PAYMENT.CNTRY_CD = GLM_PAYMENT_APPROVAL.CNTRY_CD
    JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.cmply_glm_pymt_appv_stat_txt GLM_PYMNT_APPV_STAT_TXT ON GLM_PAYMENT_APPROVAL.GLM_PYMT_APPV_STAT_CD = GLM_PYMNT_APPV_STAT_TXT.GLM_PYMT_APPV_STAT_CD
    AND GLM_PAYMENT.CNTRY_CD = GLM_PYMNT_APPV_STAT_TXT.CNTRY_CD
    AND GLM_PAYMENT_METHOD_TXT.LANG_CD = GLM_PYMNT_APPV_STAT_TXT.LANG_CD
    JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.cmply_glm_pymt_line GLM_PAYMENT_LINE ON GLM_PAYMENT.PYMT_NBR = GLM_PAYMENT_LINE.PYMT_NBR
    AND GLM_PAYMENT.GEN_LDGR_ACCT_NBR = GLM_PAYMENT_LINE.GEN_LDGR_ACCT_NBR
    AND GLM_PAYMENT.CNTRY_CD = GLM_PAYMENT_LINE.CNTRY_CD
    JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.cmply_glm_pymt_type GLM_PAYMENT_TYPE ON GLM_PAYMENT_LINE.GLM_PYMT_TYPE_CD = GLM_PAYMENT_TYPE.GLM_PYMT_TYPE_CD
    AND GLM_PAYMENT_LINE.CNTRY_CD = GLM_PAYMENT_TYPE.CNTRY_CD
    JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.cmply_glm_pymt_type_txt GLM_PAYMENT_TYPE_TXT ON GLM_PAYMENT_LINE.GLM_PYMT_TYPE_CD = GLM_PAYMENT_TYPE_TXT.GLM_PYMT_TYPE_CD
    AND GLM_PAYMENT_LINE.CNTRY_CD = GLM_PAYMENT_TYPE_TXT.CNTRY_CD
    AND GLM_PAYMENT_METHOD_TXT.LANG_CD = GLM_PAYMENT_TYPE_TXT.LANG_CD;

-- GLM_MILESTONE_D_VW - PK : LIC_SK_ID, GLM_MLSTN_CD, LANG_CD (Historical)
create
or replace table `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_milestone_d_vw_v2 AS
SELECT
    DISTINCT GLM_LICENSE_MILESTONE.LIC_SK_ID as lic_sk_id,
    TRIM(GLM_LICENSE_MILESTONE.CNTRY_CD) AS cntry_cd,
    GLM_LICENSE_MILESTONE.GLM_MLSTN_CD AS glm_mlstn_cd,
    GLM_LICENSE_MILESTONE.LIC_MLSTN_SEQ_NBR AS lic_mlstn_seq_nbr,
    GLM_LICENSE_MILESTONE.MLSTN_CMPLT_IND AS mlstn_cmplt_ind,
    GLM_LICENSE_MILESTONE.CURR_MLSTN_IND AS curr_mlstn_ind,
    GLM_LICENSE_MILESTONE.CREATE_USERID AS create_userid,
    GLM_LICENSE_MILESTONE.CREATE_TS AS create_ts,
    GLM_LICENSE_MILESTONE.LAST_CHNG_USERID AS last_chng_userid,
    GLM_LICENSE_MILESTONE.LAST_CHNG_TS AS last_chng_ts,
    TRIM(GLM_MILESTONE_TXT.GLM_MLSTN_DESC) AS glm_mlstn_desc,
    TRIM(GLM_MILESTONE_TXT.LANG_CD) AS lang_cd
FROM
    `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_glm_lic_mlstn GLM_LICENSE_MILESTONE
    JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_glm_mlstn_txt GLM_MILESTONE_TXT ON TRIM(COALESCE(GLM_LICENSE_MILESTONE.CNTRY_CD, '')) = TRIM(COALESCE(GLM_MILESTONE_TXT.CNTRY_CD, ''))
    AND GLM_LICENSE_MILESTONE.GLM_MLSTN_CD = GLM_MILESTONE_TXT.GLM_MLSTN_CD;

-- GLM_MILESTONE_D_VW - PK : LIC_SK_ID, LANG_CD (Multiple Languages)
create
or replace table `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_milestone_d_vw_v3 AS
SELECT
    GLM_LICENSE_MILESTONE.LIC_SK_ID as lic_sk_id,
    TRIM(GLM_LICENSE_MILESTONE.CNTRY_CD) as cntry_cd,
    MAX(
        CASE
            WHEN GLM_LICENSE_MILESTONE.CURR_MLSTN_IND = 1 THEN GLM_LICENSE_MILESTONE.GLM_MLSTN_CD
            WHEN GLM_LICENSE_MILESTONE.CURR_MLSTN_IND = 0 THEN 0
        END
    ) as curr_glm_milestone_cd,
    MAX(
        CASE
            WHEN GLM_LICENSE_MILESTONE.CURR_MLSTN_IND = 1 THEN GLM_LICENSE_MILESTONE.LIC_MLSTN_SEQ_NBR
            WHEN GLM_LICENSE_MILESTONE.CURR_MLSTN_IND = 0 THEN 0
        END
    ) as curr_license_milestone_seq_nbr,
    MAX(
        CASE
            WHEN GLM_LICENSE_MILESTONE.CURR_MLSTN_IND = 1 THEN GLM_LICENSE_MILESTONE.MLSTN_CMPLT_IND
            WHEN GLM_LICENSE_MILESTONE.CURR_MLSTN_IND = 0 THEN 0
        END
    ) as curr_milestone_complete_ind,
    MAX(GLM_LICENSE_MILESTONE.CURR_MLSTN_IND) AS current_milestone_ind,
    MAX(
        CASE
            WHEN GLM_LICENSE_MILESTONE.CURR_MLSTN_IND = 1 THEN GLM_LICENSE_MILESTONE.CREATE_USERID
            WHEN GLM_LICENSE_MILESTONE.CURR_MLSTN_IND = 0 THEN ''
        END
    ) as curr_create_userid,
    MAX(
        CASE
            WHEN GLM_LICENSE_MILESTONE.CURR_MLSTN_IND = 1 THEN GLM_LICENSE_MILESTONE.CREATE_TS
            WHEN GLM_LICENSE_MILESTONE.CURR_MLSTN_IND = 0 THEN CAST(PARSE_DATETIME("%F", "1970-01-01") AS TIMESTAMP)
        END
    ) as curr_create_ts,
    MAX(
        CASE
            WHEN GLM_LICENSE_MILESTONE.CURR_MLSTN_IND = 1 THEN GLM_LICENSE_MILESTONE.LAST_CHNG_USERID
            WHEN GLM_LICENSE_MILESTONE.CURR_MLSTN_IND = 0 THEN ''
        END
    ) as curr_last_chg_userid,
    MAX(
        CASE
            WHEN GLM_LICENSE_MILESTONE.CURR_MLSTN_IND = 1 THEN GLM_LICENSE_MILESTONE.LAST_CHNG_TS
            WHEN GLM_LICENSE_MILESTONE.CURR_MLSTN_IND = 0 THEN CAST(PARSE_DATETIME("%F", "1970-01-01") AS TIMESTAMP)
        END
    ) as curr_last_chg_ts,
    MAX(
        CASE
            WHEN GLM_LICENSE_MILESTONE.CURR_MLSTN_IND = 1 THEN TRIM(GLM_MILESTONE_TXT.GLM_MLSTN_DESC)
            ELSE ''
        END
    ) as curr_glm_mlstn_desc,
    TRIM(GLM_MILESTONE_TXT.LANG_CD) as LANG_CD,
    MAX(
        CASE
            WHEN GLM_LICENSE_MILESTONE.GLM_MLSTN_CD = 5 THEN GLM_LICENSE_MILESTONE.MLSTN_CMPLT_IND
            ELSE 0
        END
    ) as glm_mlstn_cd_5_complete_ind,
    MAX(
        CASE
            WHEN GLM_LICENSE_MILESTONE.GLM_MLSTN_CD = 5 THEN GLM_LICENSE_MILESTONE.LAST_CHNG_TS
            ELSE CAST(PARSE_DATETIME("%F", "1970-01-01") AS TIMESTAMP)
        END
    ) as glm_mlstn_cd_5_last_chg_ts,
FROM
    `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_glm_lic_mlstn GLM_LICENSE_MILESTONE
    JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_glm_mlstn_txt GLM_MILESTONE_TXT ON TRIM(COALESCE(GLM_LICENSE_MILESTONE.CNTRY_CD, '')) = TRIM(COALESCE(GLM_MILESTONE_TXT.CNTRY_CD, ''))
    AND GLM_LICENSE_MILESTONE.GLM_MLSTN_CD = GLM_MILESTONE_TXT.GLM_MLSTN_CD
GROUP BY
    GLM_LICENSE_MILESTONE.LIC_SK_ID,
    TRIM(GLM_LICENSE_MILESTONE.CNTRY_CD),
    TRIM(GLM_MILESTONE_TXT.LANG_CD);

-- GLM_LIC_BU_F_VW : PK : LIC_SK_ID, BU_SK_ID
create
or replace table `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_lic_bu_f_vw_v1 AS
SELECT
    CMPLY_GLM_LIC_BU.LIC_SK_ID AS lic_sk_id,
    CMPLY_GLM_LIC_BU.BU_SK_ID AS bu_sk_id,
    CASE
        WHEN BU_DIM.BUSINESS_TYPE_DESC = 'STORE' THEN STORE_DIM.STATE_PROV_CODE
        WHEN BU_DIM.BUSINESS_TYPE_DESC = 'DC' THEN DC_DIM.STATE_CODE
        WHEN BU_DIM.BUSINESS_TYPE_DESC = 'CLUB' THEN CLUB_DIM.STATE_PROV_CODE
    END AS state,
    CASE
        WHEN BU_DIM.BUSINESS_TYPE_DESC = 'STORE' THEN STORE_DIM.CITY_NAME
        WHEN BU_DIM.BUSINESS_TYPE_DESC = 'DC' THEN DC_DIM.CITY_NAME
        WHEN BU_DIM.BUSINESS_TYPE_DESC = 'CLUB' THEN CLUB_DIM.CITY_NAME
    END city,
    CASE
        WHEN BU_DIM.BUSINESS_TYPE_DESC = 'STORE' THEN STORE_DIM.BANNER_DESC
        WHEN BU_DIM.BUSINESS_TYPE_DESC = 'CLUB' THEN CLUB_DIM.BANNER_DESC
    END AS banner_description,
    COALESCE(BU_DIM.STORE_NBR, -9999) AS store_nbr,
    COALESCE(BU_DIM.OPEN_DATE, CURRENT_DATE) AS open_date,
    CASE
        WHEN BU_DIM.BUSINESS_TYPE_DESC = 'STORE' THEN STORE_DIM.OPEN_STATUS_DESC
        WHEN BU_DIM.BUSINESS_TYPE_DESC = 'CLUB' THEN CLUB_DIM.OPEN_STATUS_DESC
    END AS open_status_desc,
    DATE_DIFF(
        CURRENT_TIMESTAMP,
        CAST(
            COALESCE(BU_DIM.OPEN_DATE, CURRENT_DATE) AS TIMESTAMP
        ),
        DAY
    ) AS future_stores,
    COALESCE(BU_DIM.COUNTRY_CODE, '') AS cntry_cd,
    CASE
        COALESCE(BU_DIM.COUNTRY_CODE, '')
        WHEN 'K1' THEN 'CAM'
        WHEN 'K2' THEN 'CL'
        WHEN 'CL' THEN 'CL(Dept)'
        WHEN 'GB' THEN 'UK'
        WHEN 'K3' THEN 'AF'
        WHEN 'ZA' THEN 'AF'
        ELSE COALESCE(BU_DIM.COUNTRY_CODE, '')
    END AS market,
    COALESCE(BU_DIM.BUSINESS_TYPE_DESC, '') AS business_type_desc,
    CASE
        WHEN BU_DIM.BUSINESS_TYPE_DESC = 'STORE' THEN STORE_DIM.SUBDIV_NBR
        WHEN BU_DIM.BUSINESS_TYPE_DESC = 'DC' THEN DC_DIM.SUBDIVISION_NBR
        WHEN BU_DIM.BUSINESS_TYPE_DESC = 'CLUB' THEN CLUB_DIM.SUBDIV_NBR
    END AS subdiv_nbr
FROM
    `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_glm_lic_bu CMPLY_GLM_LIC_BU
    LEFT OUTER JOIN (
        select
            BU_SK_ID,
            -- CITY_NAME,
            STORE_NBR,
            OPEN_DATE,
            COUNTRY_CODE,
            TRIM(UPPER(BUSINESS_TYPE_DESC)) AS BUSINESS_TYPE_DESC -- SUBDIV_NBR
        FROM
            `wmt-edw-prod`.WW_CORE_DIM_VM.BU_DIM -- WHERE
            --     CURRENT_IND = 'Y'
        UNION
        ALL
        SELECT
            BU_SK_ID,
            -- '' AS CITY_NAME,
            STORE_NBR,
            CAST(OPEN_DT AS DATE) AS OPEN_DATE,
            CNTRY_CD AS COUNTRY_CODE,
            TRIM(UPPER(BUS_TYPE_DESC)) AS BUSINESS_TYPE_DESC -- '-99' AS SUBDIV_NBR
        FROM
            `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_bu_dim -- WHERE
            --     CURR_IND = 'Y'
    ) BU_DIM ON CMPLY_GLM_LIC_BU.BU_SK_ID = BU_DIM.BU_SK_ID
    LEFT OUTER JOIN (
        SELECT
            *
        FROM
            `wmt-edw-prod`.WW_CORE_DIM_VM.STORE_DIM -- WHERE
            --     CURRENT_IND = 'Y'
    ) STORE_DIM ON BU_DIM.BU_SK_ID = STORE_DIM.STORE_SK_ID
    AND BU_DIM.COUNTRY_CODE = STORE_DIM.COUNTRY_CODE
    LEFT OUTER JOIN (
        SELECT
            *
        FROM
            `wmt-edw-prod`.WW_CORE_DIM_VM.CLUB_DIM -- WHERE
            --     CURRENT_IND = 'Y'
    ) CLUB_DIM ON BU_DIM.BU_SK_ID = CLUB_DIM.CLUB_SK_ID
    AND BU_DIM.COUNTRY_CODE = CLUB_DIM.COUNTRY_CODE
    LEFT OUTER JOIN (
        SELECT
            *
        FROM
            `wmt-edw-prod`.WW_CORE_DIM_VM.DC_DIM -- WHERE
            --     CURRENT_IND = 'Y'
    ) DC_DIM ON BU_DIM.BU_SK_ID = DC_DIM.DC_SK_ID
    AND BU_DIM.COUNTRY_CODE = DC_DIM.COUNTRY_CODE;

-- GLM_TASK_DIM_F_VW - PK : TASK_SK_ID, LANG_CD (All milestone and languages)
create
or replace table `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_task_dim_f_vw_v2 AS
SELECT
    GLM_TASK_DIM.LIC_SK_ID AS lic_sk_id,
    GLM_TASK_DIM.TASK_SK_ID AS task_sk_id,
    GLM_TASK_DIM.GLM_TASK_ID AS glm_task_id,
    GLM_TASK_DIM.CURR_IND AS curr_ind,
    GLM_TASK_DIM.SNAPSHOT_BEG_DT AS snapshot_beg_dt,
    GLM_TASK_DIM.SNAPSHOT_END_DT AS snapshot_end_dt,
    GLM_TASK_DIM.GLM_MLSTN_CD AS glm_mlstn_cd,
    CAST(TRIM(GLM_TASK_DIM.TASK_SEQ_NBR) AS NUMERIC) AS task_seq_nbr,
    GLM_TASK_DIM.TASK_PRE_REQ_RSN_CD AS task_pre_req_rsn_cd,
    GLM_TASK_DIM.TASK_PRE_REQ_AREA_CD AS task_pre_req_area_cd,
    CAST(GLM_TASK_DIM.TASK_PRE_REQ_DUE_TS AS DATE) AS task_pre_req_due_ts,
    GLM_TASK_DIM.GLM_TASK_STATUS_CD AS glm_task_status_cd,
    GLM_TASK_DIM.DOC_REQD_IND AS doc_reqd_ind,
    GLM_TASK_DIM.PYMT_REQD_IND AS pymt_reqd_ind,
    GLM_TASK_DIM.TASK_PRE_REQ_FNSH_IND AS task_pre_req_fnsh_ind,
    GLM_TASK_DIM.CNTRY_CD AS cntry_cd,
    GLM_TASK_DIM.REQ_LIC_DOC_TYPE_CD AS req_lic_doc_type_cd,
    GLM_TASK_DIM.TASK_CREATE_USER_ID AS task_create_user_id,
    GLM_TASK_DIM.TASK_CREATE_TS AS task_create_ts,
    GLM_TASK_DIM.TASK_LAST_CHNG_USER_ID AS task_last_chng_user_id,
    GLM_TASK_DIM.TASK_LAST_CHNG_TS AS task_last_chng_ts,
    CASE
        WHEN DATE_DIFF(
            CAST(GLM_TASK_DIM.TASK_PRE_REQ_DUE_TS AS DATE),
            CURRENT_DATE,
            DAY
        ) <= -91 THEN '-91+'
        WHEN DATE_DIFF(
            CAST(GLM_TASK_DIM.TASK_PRE_REQ_DUE_TS AS DATE),
            CURRENT_DATE,
            DAY
        ) > -91
        AND DATE_DIFF(
            CAST(GLM_TASK_DIM.TASK_PRE_REQ_DUE_TS AS DATE),
            CURRENT_DATE,
            DAY
        ) <= -61 THEN '-90 to -61'
        WHEN DATE_DIFF(
            CAST(GLM_TASK_DIM.TASK_PRE_REQ_DUE_TS AS DATE),
            CURRENT_DATE,
            DAY
        ) > -61
        AND DATE_DIFF(
            CAST(GLM_TASK_DIM.TASK_PRE_REQ_DUE_TS AS DATE),
            CURRENT_DATE,
            DAY
        ) <= -31 THEN '-60 to -31'
        WHEN DATE_DIFF(
            CAST(GLM_TASK_DIM.TASK_PRE_REQ_DUE_TS AS DATE),
            CURRENT_DATE,
            DAY
        ) > -31
        AND DATE_DIFF(
            CAST(GLM_TASK_DIM.TASK_PRE_REQ_DUE_TS AS DATE),
            CURRENT_DATE,
            DAY
        ) <= -1 THEN '-30 to -1'
        WHEN DATE_DIFF(
            CAST(GLM_TASK_DIM.TASK_PRE_REQ_DUE_TS AS DATE),
            CURRENT_DATE,
            DAY
        ) >= 0
        AND DATE_DIFF(
            CAST(GLM_TASK_DIM.TASK_PRE_REQ_DUE_TS AS DATE),
            CURRENT_DATE,
            DAY
        ) <= 30 THEN '0 to 30'
        WHEN DATE_DIFF(
            CAST(GLM_TASK_DIM.TASK_PRE_REQ_DUE_TS AS DATE),
            CURRENT_DATE,
            DAY
        ) > 30
        AND DATE_DIFF(
            CAST(GLM_TASK_DIM.TASK_PRE_REQ_DUE_TS AS DATE),
            CURRENT_DATE,
            DAY
        ) <= 60 THEN '31 to 60'
        WHEN DATE_DIFF(
            CAST(GLM_TASK_DIM.TASK_PRE_REQ_DUE_TS AS DATE),
            CURRENT_DATE,
            DAY
        ) > 60
        AND DATE_DIFF(
            CAST(GLM_TASK_DIM.TASK_PRE_REQ_DUE_TS AS DATE),
            CURRENT_DATE,
            DAY
        ) <= 90 THEN '61 to 90'
        WHEN DATE_DIFF(
            CAST(GLM_TASK_DIM.TASK_PRE_REQ_DUE_TS AS DATE),
            CURRENT_DATE,
            DAY
        ) > 90
        AND DATE_DIFF(
            CAST(GLM_TASK_DIM.TASK_PRE_REQ_DUE_TS AS DATE),
            CURRENT_DATE,
            DAY
        ) <= 120 THEN '91 to 120'
        WHEN DATE_DIFF(
            CAST(GLM_TASK_DIM.TASK_PRE_REQ_DUE_TS AS DATE),
            CURRENT_DATE,
            DAY
        ) > 120
        AND DATE_DIFF(
            CAST(GLM_TASK_DIM.TASK_PRE_REQ_DUE_TS AS DATE),
            CURRENT_DATE,
            DAY
        ) <= 150 THEN '121 to 150'
        WHEN DATE_DIFF(
            CAST(GLM_TASK_DIM.TASK_PRE_REQ_DUE_TS AS DATE),
            CURRENT_DATE,
            DAY
        ) > 150 THEN '151+'
    END AS task_pre_req_due_time_range,
    GLM_MILESTONE_D_VW.LIC_MLSTN_SEQ_NBR AS lic_mlstn_seq_nbr,
    GLM_MILESTONE_D_VW.MLSTN_CMPLT_IND AS mlstn_cmplt_ind,
    GLM_MILESTONE_D_VW.CURR_MLSTN_IND AS curr_mlstn_ind,
    GLM_MILESTONE_D_VW.GLM_MLSTN_DESC AS glm_mlstn_desc,
    GLM_MILESTONE_D_VW.LAST_CHNG_TS AS last_chng_ts,
    GLM_MILESTONE_D_VW.CREATE_TS AS create_ts,
    GLM_TASK_TXT.LANG_CD AS lang_cd,
    TRIM(GLM_TASK_TXT.TASK_NM) AS task_nm,
    COALESCE(
        GLM_TASK_PREREQ_RSN_TXT.TASK_PRE_REQ_RSN_DESC,
        ''
    ) AS task_pre_req_rsn_desc,
    COALESCE(
        GLM_TSK_PREREQ_AREA_TXT.TASK_PRE_REQ_AREA_DESC,
        ''
    ) AS task_pre_req_area_desc,
    TRIM(GLM_TASK_STATUS_TXT.GLM_TASK_STATUS_DESC) AS glm_task_status_desc
FROM
    `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_glm_task_dim GLM_TASK_DIM
    JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_glm_task_txt GLM_TASK_TXT ON GLM_TASK_DIM.TASK_SK_ID = GLM_TASK_TXT.TASK_SK_ID
    JOIN `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_milestone_d_vw_v2 GLM_MILESTONE_D_VW ON GLM_TASK_DIM.LIC_SK_ID = GLM_MILESTONE_D_VW.LIC_SK_ID
    AND TRIM(COALESCE(GLM_TASK_DIM.CNTRY_CD, '')) = TRIM(COALESCE(GLM_MILESTONE_D_VW.CNTRY_CD, ''))
    AND GLM_TASK_DIM.GLM_MLSTN_CD = GLM_MILESTONE_D_VW.GLM_MLSTN_CD
    AND TRIM(COALESCE(GLM_TASK_TXT.LANG_CD, '')) = TRIM(COALESCE(GLM_MILESTONE_D_VW.LANG_CD, ''))
    LEFT OUTER JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_glm_task_pre_req_rsn_txt GLM_TASK_PREREQ_RSN_TXT ON GLM_TASK_DIM.TASK_PRE_REQ_RSN_CD = GLM_TASK_PREREQ_RSN_TXT.TASK_PRE_REQ_RSN_CD
    AND GLM_TASK_DIM.CNTRY_CD = GLM_TASK_PREREQ_RSN_TXT.CNTRY_CD
    AND GLM_TASK_TXT.LANG_CD = GLM_TASK_PREREQ_RSN_TXT.LANG_CD
    LEFT OUTER JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_glm_task_pre_req_area_txt GLM_TSK_PREREQ_AREA_TXT ON GLM_TASK_DIM.TASK_PRE_REQ_AREA_CD = GLM_TSK_PREREQ_AREA_TXT.TASK_PRE_REQ_AREA_CD
    AND GLM_TASK_DIM.CNTRY_CD = GLM_TSK_PREREQ_AREA_TXT.CNTRY_CD
    AND GLM_TASK_TXT.LANG_CD = GLM_TSK_PREREQ_AREA_TXT.LANG_CD
    JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.cmply_glm_task_status_txt GLM_TASK_STATUS_TXT ON GLM_TASK_DIM.GLM_TASK_STATUS_CD = GLM_TASK_STATUS_TXT.GLM_TASK_STATUS_CD
    AND GLM_TASK_DIM.CNTRY_CD = GLM_TASK_STATUS_TXT.CNTRY_CD
    AND GLM_TASK_TXT.LANG_CD = GLM_TASK_STATUS_TXT.LANG_CD;

-- GLM_CONTACT_F_VW - PK : GLM_CNTCT_ID, CNTRY_CD, LANG_CD
create
or replace table `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_contact_f_vw_v1 AS
SELECT
    *
FROM
    (
        SELECT
            GLM_CONTACT.GLM_CNTCT_ID AS glm_cntct_id,
            GLM_CONTACT.LIC_SK_ID AS glm_lic_appln_id,
            GLM_CONTACT.GLM_CNTCT_TYPE_CD AS glm_cntct_type_cd,
            GLM_CONTACT.GLM_CNTCT_LINE1 AS glm_cntct_line1,
            GLM_CONTACT.GLM_CNTCT_LINE2 AS glm_cntct_line2,
            TRIM(GLM_CONTACT.GLM_CNTCT_LINE3) AS glm_cntct_line3,
            TRIM(GLM_CONTACT.GLM_CNTCT_LINE4) AS glm_cntct_line4,
            TRIM(GLM_CONTACT.GLM_CNTCT_LINE5) AS glm_cntct_line5,
            TRIM(GLM_CONTACT.GLM_CNTCT_TXT) AS glm_cntct_txt,
            GLM_CONTACT.CNTRY_CD AS cntry_cd,
            GLM_CONTACT.CNTCT_CREATE_TS AS create_ts,
            GLM_CONTACT.CNTCT_LAST_CHNG_TS AS last_chg_ts,
            TRIM(GLM_CONTACT_TYPE_TXT.GLM_CNTCT_TYPE_DESC) AS glm_cntct_type_desc,
            TRIM(GLM_CONTACT_TYPE_TXT.LANG_CD) AS LANG_CD,
            ROW_NUMBER() OVER(
                PARTITION BY GLM_CONTACT.LIC_SK_ID,
                GLM_CONTACT.GLM_CNTCT_TYPE_CD,
                GLM_CONTACT.CNTRY_CD,
                GLM_CONTACT_TYPE_TXT.LANG_CD
                ORDER BY
                    GLM_CONTACT.CNTCT_LAST_CHNG_TS DESC
            ) AS row_num -- to handle cases where 2 instances of the contact_type_cd are present with later update_ts
        FROM
            `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_glm_cntct GLM_CONTACT
            JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_glm_cntct_type_txt GLM_CONTACT_TYPE_TXT ON GLM_CONTACT.GLM_CNTCT_TYPE_CD = GLM_CONTACT_TYPE_TXT.GLM_CNTCT_TYPE_CD
            AND GLM_CONTACT.CNTRY_CD = GLM_CONTACT_TYPE_TXT.CNTRY_CD
    ) glm_contact
WHERE
    row_num = 1;

-- GLM_LICENSE_TYPE_D_VW - PK : LIC_SK_ID, GLM_APPLN_TYPE_CD, GLM_LIC_CLASS_CD, GLM_LIC_CATG_CD, LIC_TYPE_CD, CNTRY_CD, LANG_CD (Multiple Languages)
create
or replace table `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_license_type_d_vw_v2 AS
SELECT
    GLM_LICENSE_TYPE_GROUP.LIC_SK_ID AS lic_sk_id,
    GLM_LICENSE_TYPE_GROUP.CNTRY_CD AS cntry_cd,
    GLM_LICENSE_TYPE_GROUP.GLM_APPLN_TYPE_CD AS glm_appln_type_cd,
    GLM_LICENSE_TYPE_GROUP.GLM_LIC_CLASS_CD AS glm_lic_class_cd,
    GLM_LICENSE_TYPE_GROUP.GLM_LIC_CATG_CD AS glm_lic_catg_cd,
    GLM_LICENSE_TYPE_GROUP.LIC_TYPE_CD AS lic_type_cd,
    TRIM(GLM_LICENSE_TYPE_TXT.LANG_CD) AS lang_cd,
    TRIM(GLM_LICENSE_TYPE_TXT.LIC_TYPE_DESC) AS lic_type_desc,
    TRIM(GLM_LICENSE_CATG_TXT.GLM_LIC_CATG_DESC) AS glm_lic_catg_desc,
    TRIM(GLM_APPLICATION_TYPE_TXT.GLM_APPLN_TYPE_DESC) AS glm_appln_type_desc,
    TRIM(GLM_LICENSE_CLASS_TXT.GLM_LIC_CLASS_DESC) AS glm_lic_class_desc
FROM
    `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_glm_lic_type_grp GLM_LICENSE_TYPE_GROUP
    JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_glm_lic_type_txt GLM_LICENSE_TYPE_TXT ON TRIM(GLM_LICENSE_TYPE_GROUP.LIC_TYPE_CD) = CAST(GLM_LICENSE_TYPE_TXT.LIC_TYPE_CD AS STRING)
    AND GLM_LICENSE_TYPE_GROUP.CNTRY_CD = GLM_LICENSE_TYPE_TXT.CNTRY_CD
    JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_glm_lic_catg_txt GLM_LICENSE_CATG_TXT ON TRIM(GLM_LICENSE_TYPE_GROUP.GLM_LIC_CATG_CD) = CAST(GLM_LICENSE_CATG_TXT.GLM_LIC_CATG_CD AS STRING)
    AND GLM_LICENSE_TYPE_GROUP.CNTRY_CD = GLM_LICENSE_CATG_TXT.CNTRY_CD
    AND TRIM(GLM_LICENSE_TYPE_TXT.LANG_CD) = TRIM(GLM_LICENSE_CATG_TXT.LANG_CD)
    JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_glm_appln_type_txt GLM_APPLICATION_TYPE_TXT ON TRIM(GLM_LICENSE_TYPE_GROUP.GLM_APPLN_TYPE_CD) = CAST(
        GLM_APPLICATION_TYPE_TXT.GLM_APPLN_TYPE_CD AS STRING
    )
    AND GLM_LICENSE_TYPE_GROUP.CNTRY_CD = GLM_APPLICATION_TYPE_TXT.CNTRY_CD
    AND TRIM(GLM_LICENSE_TYPE_TXT.LANG_CD) = TRIM(GLM_APPLICATION_TYPE_TXT.LANG_CD)
    JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_glm_lic_class_txt GLM_LICENSE_CLASS_TXT ON TRIM(GLM_LICENSE_TYPE_GROUP.GLM_LIC_CLASS_CD) = CAST(GLM_LICENSE_CLASS_TXT.GLM_LIC_CLASS_CD AS STRING)
    AND GLM_LICENSE_TYPE_GROUP.CNTRY_CD = GLM_LICENSE_CLASS_TXT.CNTRY_CD
    AND TRIM(GLM_LICENSE_TYPE_TXT.LANG_CD) = TRIM(GLM_LICENSE_CLASS_TXT.LANG_CD);

-- GLM_LICENSE_F_VW - PK : LIC_SK_ID, LANG_CD (Metrics and Languages)
create
or replace table `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_license_f_vw_v2 AS
SELECT
    CMPLY_GLM_LIC_DIM.LIC_SK_ID AS lic_sk_id,
    CMPLY_GLM_LIC_DIM.GLM_LIC_STATUS_CD as glm_license_status_cd,
    CMPLY_GLM_LIC_DIM.EXP_DT AS exp_dt,
    TRIM(CMPLY_GLM_LIC_DIM.LIC_ACTV_DESC) as lic_actv_desc,
    CMPLY_GLM_LIC_DIM.GLM_ACTV_CLASS_CD AS glm_actv_class_cd,
    CAST(CMPLY_GLM_LIC_DIM.MULT_DOC_IND AS INT64) AS mult_doc_ind,
    CMPLY_GLM_LIC_DIM.GLM_LIC_APPLN_ID AS glm_lic_appln_id,
    CASE
        WHEN DATE_DIFF(
            CAST(CURRENT_DATE AS TIMESTAMP),
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS TIMESTAMP),
            DAY
        ) <= 90 THEN '0-3 Months'
        WHEN DATE_DIFF(
            CAST(CURRENT_DATE AS TIMESTAMP),
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS TIMESTAMP),
            DAY
        ) > 90
        AND DATE_DIFF(
            CAST(CURRENT_DATE AS TIMESTAMP),
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS TIMESTAMP),
            DAY
        ) <= 180 THEN '3-6 Months'
        WHEN DATE_DIFF(
            CAST(CURRENT_DATE AS TIMESTAMP),
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS TIMESTAMP),
            DAY
        ) > 180
        AND DATE_DIFF(
            CAST(CURRENT_DATE AS TIMESTAMP),
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS TIMESTAMP),
            DAY
        ) <= 365 THEN '6-12 Months'
        WHEN DATE_DIFF(
            CAST(CURRENT_DATE AS TIMESTAMP),
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS TIMESTAMP),
            DAY
        ) > 365 THEN '1 Years +'
    END AS time_range,
    CASE
        WHEN DATE_DIFF(
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS DATE),
            CURRENT_DATE,
            DAY
        ) <= -91 THEN '-91+'
        WHEN DATE_DIFF(
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS DATE),
            CURRENT_DATE,
            DAY
        ) > -91
        AND DATE_DIFF(
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS DATE),
            CURRENT_DATE,
            DAY
        ) <= -61 THEN '-90 to -61'
        WHEN DATE_DIFF(
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS DATE),
            CURRENT_DATE,
            DAY
        ) > -61
        AND DATE_DIFF(
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS DATE),
            CURRENT_DATE,
            DAY
        ) <= -31 THEN '-60 to -31'
        WHEN DATE_DIFF(
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS DATE),
            CURRENT_DATE,
            DAY
        ) > -31
        AND DATE_DIFF(
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS DATE),
            CURRENT_DATE,
            DAY
        ) <= -1 THEN '-30 to -1'
        WHEN DATE_DIFF(
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS DATE),
            CURRENT_DATE,
            DAY
        ) >= 0
        AND DATE_DIFF(
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS DATE),
            CURRENT_DATE,
            DAY
        ) <= 30 THEN '0 to 30'
        WHEN DATE_DIFF(
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS DATE),
            CURRENT_DATE,
            DAY
        ) > 30
        AND DATE_DIFF(
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS DATE),
            CURRENT_DATE,
            DAY
        ) <= 60 THEN '31 to 60'
        WHEN DATE_DIFF(
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS DATE),
            CURRENT_DATE,
            DAY
        ) > 60
        AND DATE_DIFF(
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS DATE),
            CURRENT_DATE,
            DAY
        ) <= 90 THEN '61 to 90'
        WHEN DATE_DIFF(
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS DATE),
            CURRENT_DATE,
            DAY
        ) > 90
        AND DATE_DIFF(
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS DATE),
            CURRENT_DATE,
            DAY
        ) <= 120 THEN '91 to 120'
        WHEN DATE_DIFF(
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS DATE),
            CURRENT_DATE,
            DAY
        ) > 120
        AND DATE_DIFF(
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS DATE),
            CURRENT_DATE,
            DAY
        ) <= 150 THEN '121 to 150'
        WHEN DATE_DIFF(
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS DATE),
            CURRENT_DATE,
            DAY
        ) > 150 THEN '151+'
    END as expiration_time_range,
    CASE
        WHEN DATE_DIFF(
            CAST(CURRENT_DATE AS TIMESTAMP),
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS TIMESTAMP),
            DAY
        ) <= 90 THEN '1'
        WHEN DATE_DIFF(
            CAST(CURRENT_DATE AS TIMESTAMP),
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS TIMESTAMP),
            DAY
        ) > 90
        AND DATE_DIFF(
            CAST(CURRENT_DATE AS TIMESTAMP),
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS TIMESTAMP),
            DAY
        ) <= 180 THEN '2'
        WHEN DATE_DIFF(
            CAST(CURRENT_DATE AS TIMESTAMP),
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS TIMESTAMP),
            DAY
        ) > 180
        AND DATE_DIFF(
            CAST(CURRENT_DATE AS TIMESTAMP),
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS TIMESTAMP),
            DAY
        ) <= 365 THEN '3'
        WHEN DATE_DIFF(
            CAST(CURRENT_DATE AS TIMESTAMP),
            CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS TIMESTAMP),
            DAY
        ) > 365 THEN '4'
    END AS serial_no,
    CASE
        WHEN CMPLY_GLM_LIC_DIM.GLM_ACTV_CLASS_CD = 2
        AND CAST(CMPLY_GLM_LIC_DIM.MULT_DOC_IND AS INT64) = 1
        AND CMPLY_GLM_LIC_DIM.GLM_LIC_STATUS_CD = 3 THEN 'Valid Multiple Normal'
        WHEN CMPLY_GLM_LIC_DIM.GLM_ACTV_CLASS_CD = 1
        AND CAST(CMPLY_GLM_LIC_DIM.MULT_DOC_IND AS INT64) = 1
        AND CMPLY_GLM_LIC_DIM.GLM_LIC_STATUS_CD = 3 THEN 'Valid Multiple Business'
        WHEN CAST(CMPLY_GLM_LIC_DIM.MULT_DOC_IND AS INT64) = 0
        AND CMPLY_GLM_LIC_DIM.GLM_LIC_STATUS_CD = 3 THEN 'Valid Master'
    END AS valid_ind,
    CASE
        WHEN CMPLY_GLM_LIC_DIM.GLM_ACTV_CLASS_CD = 2
        AND CAST(CMPLY_GLM_LIC_DIM.MULT_DOC_IND AS INT64) = 1
        AND CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS TIMESTAMP) > CAST(CURRENT_DATE AS TIMESTAMP)
        AND (
            TRIM(CMPLY_GLM_LIC_DIM.LIC_ACTV_DESC) = 'NEW'
            OR TRIM(CMPLY_GLM_LIC_DIM.LIC_ACTV_DESC) = ''
        )
        AND CMPLY_GLM_LIC_DIM.GLM_LIC_STATUS_CD IN (2, 6, 7) THEN 'New Multiple Normal'
        WHEN CMPLY_GLM_LIC_DIM.GLM_ACTV_CLASS_CD = 1
        AND CAST(CMPLY_GLM_LIC_DIM.MULT_DOC_IND AS INT64) = 1
        AND CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS TIMESTAMP) > CAST(CURRENT_DATE AS TIMESTAMP)
        AND (
            TRIM(CMPLY_GLM_LIC_DIM.LIC_ACTV_DESC) = 'NEW'
            OR TRIM(CMPLY_GLM_LIC_DIM.LIC_ACTV_DESC) = ''
        )
        AND CMPLY_GLM_LIC_DIM.GLM_LIC_STATUS_CD IN (2, 6, 7) THEN 'New Multiple Business'
        WHEN CAST(CMPLY_GLM_LIC_DIM.MULT_DOC_IND AS INT64) = 0
        AND CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS TIMESTAMP) > CAST(CURRENT_DATE AS TIMESTAMP)
        AND (
            TRIM(CMPLY_GLM_LIC_DIM.LIC_ACTV_DESC) = 'NEW'
            OR TRIM(CMPLY_GLM_LIC_DIM.LIC_ACTV_DESC) = ''
        )
        AND CMPLY_GLM_LIC_DIM.GLM_LIC_STATUS_CD IN (2, 6, 7) THEN 'New Master'
    END AS new_ind,
    CASE
        WHEN CMPLY_GLM_LIC_DIM.GLM_ACTV_CLASS_CD = 2
        AND CAST(CMPLY_GLM_LIC_DIM.MULT_DOC_IND AS INT64) = 1
        AND CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS TIMESTAMP) > CAST(CURRENT_DATE AS TIMESTAMP)
        AND (
            CMPLY_GLM_LIC_DIM.LIC_ACTV_DESC = 'PROJECT'
            OR CMPLY_GLM_LIC_DIM.LIC_ACTV_DESC = ''
        )
        AND CMPLY_GLM_LIC_DIM.GLM_LIC_STATUS_CD IN (2, 6, 7) THEN 'New Facility Multiple Normal'
        WHEN CMPLY_GLM_LIC_DIM.GLM_ACTV_CLASS_CD = 1
        AND CAST(CMPLY_GLM_LIC_DIM.MULT_DOC_IND AS INT64) = 1
        AND CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS TIMESTAMP) > CAST(CURRENT_DATE AS TIMESTAMP)
        AND (
            CMPLY_GLM_LIC_DIM.LIC_ACTV_DESC = 'PROJECT'
            OR CMPLY_GLM_LIC_DIM.LIC_ACTV_DESC = ''
        )
        AND CMPLY_GLM_LIC_DIM.GLM_LIC_STATUS_CD IN (2, 6, 7) THEN 'New Facility Multiple Business'
        WHEN CAST(CMPLY_GLM_LIC_DIM.MULT_DOC_IND AS INT64) = 0
        AND CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS TIMESTAMP) > CAST(CURRENT_DATE AS TIMESTAMP)
        AND (
            CMPLY_GLM_LIC_DIM.LIC_ACTV_DESC = 'PROJECT'
            OR CMPLY_GLM_LIC_DIM.LIC_ACTV_DESC = ''
        )
        AND CMPLY_GLM_LIC_DIM.GLM_LIC_STATUS_CD IN (2, 6, 7) THEN 'New Facility Master'
    END AS new_facility_ind,
    CASE
        WHEN CMPLY_GLM_LIC_DIM.GLM_ACTV_CLASS_CD = 2
        AND CAST(CMPLY_GLM_LIC_DIM.MULT_DOC_IND AS INT64) = 1 THEN 'Multiple Normal'
        WHEN CMPLY_GLM_LIC_DIM.GLM_ACTV_CLASS_CD = 1
        AND CAST(CMPLY_GLM_LIC_DIM.MULT_DOC_IND AS INT64) = 1 THEN 'Multiple Business'
        WHEN CMPLY_GLM_LIC_DIM.GLM_ACTV_CLASS_CD = 3
        AND CAST(CMPLY_GLM_LIC_DIM.MULT_DOC_IND AS INT64) = 0 THEN 'Single'
        WHEN CMPLY_GLM_LIC_DIM.GLM_ACTV_CLASS_CD = 1
        AND CAST(CMPLY_GLM_LIC_DIM.MULT_DOC_IND AS INT64) = 0 THEN 'Master Business'
        WHEN CMPLY_GLM_LIC_DIM.GLM_ACTV_CLASS_CD = 2
        AND CAST(CMPLY_GLM_LIC_DIM.MULT_DOC_IND AS INT64) = 0 THEN 'Master Normal'
    END AS license_ind,
    CASE
        WHEN CMPLY_GLM_LIC_DIM.GLM_ACTV_CLASS_CD = 2
        AND CAST(CMPLY_GLM_LIC_DIM.MULT_DOC_IND AS INT64) = 1
        AND GLM_MILESTONE_D_VW.glm_mlstn_cd_5_complete_ind = 1
        AND CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS TIMESTAMP) < CAST(CURRENT_DATE AS TIMESTAMP)
        AND CMPLY_GLM_LIC_DIM.GLM_LIC_STATUS_CD IN (2, 6, 7) THEN 'PE Multiple Normal'
        WHEN CMPLY_GLM_LIC_DIM.GLM_ACTV_CLASS_CD = 1
        AND CAST(CMPLY_GLM_LIC_DIM.MULT_DOC_IND AS INT64) = 1
        AND GLM_MILESTONE_D_VW.glm_mlstn_cd_5_complete_ind = 1
        AND CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS TIMESTAMP) < CAST(CURRENT_DATE AS TIMESTAMP)
        AND CMPLY_GLM_LIC_DIM.GLM_LIC_STATUS_CD IN (2, 6, 7) THEN 'PE Multiple Business'
        WHEN CAST(CMPLY_GLM_LIC_DIM.MULT_DOC_IND AS INT64) = 0
        AND GLM_MILESTONE_D_VW.glm_mlstn_cd_5_complete_ind = 1
        AND CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS TIMESTAMP) < CAST(CURRENT_DATE AS TIMESTAMP)
        AND CMPLY_GLM_LIC_DIM.GLM_LIC_STATUS_CD IN (2, 6, 7) THEN 'PE Master'
    END AS pe_ind,
    CASE
        WHEN CMPLY_GLM_LIC_DIM.GLM_ACTV_CLASS_CD = 2
        AND CAST(CMPLY_GLM_LIC_DIM.MULT_DOC_IND AS INT64) = 1
        AND GLM_MILESTONE_D_VW.glm_mlstn_cd_5_complete_ind = 0
        AND CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS TIMESTAMP) < CAST(CURRENT_DATE AS TIMESTAMP)
        AND CMPLY_GLM_LIC_DIM.GLM_LIC_STATUS_CD IN (2, 6, 7) THEN 'PI Multiple Normal'
        WHEN CMPLY_GLM_LIC_DIM.GLM_ACTV_CLASS_CD = 1
        AND CAST(CMPLY_GLM_LIC_DIM.MULT_DOC_IND AS INT64) = 1
        AND GLM_MILESTONE_D_VW.glm_mlstn_cd_5_complete_ind = 0
        AND CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS TIMESTAMP) < CAST(CURRENT_DATE AS TIMESTAMP)
        AND CMPLY_GLM_LIC_DIM.GLM_LIC_STATUS_CD IN (2, 6, 7) THEN 'PI Multiple Business'
        WHEN CAST(CMPLY_GLM_LIC_DIM.MULT_DOC_IND AS INT64) = 0
        AND GLM_MILESTONE_D_VW.glm_mlstn_cd_5_complete_ind = 0
        AND CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS TIMESTAMP) < CAST(CURRENT_DATE AS TIMESTAMP)
        AND CMPLY_GLM_LIC_DIM.GLM_LIC_STATUS_CD IN (2, 6, 7) THEN 'PI Master'
    END AS pi_ind,
    CASE
        WHEN GLM_MILESTONE_D_VW.CURRENT_MILESTONE_IND = 1
        AND CAST(CMPLY_GLM_LIC_DIM.EXP_DT AS TIMESTAMP) > CAST(CURRENT_DATE AS TIMESTAMP)
        AND CMPLY_GLM_LIC_DIM.GLM_LIC_STATUS_DESC IN ('ASSIGNED', 'PENDING', 'UNASSIGNED') THEN CASE
            WHEN CAST(CMPLY_GLM_LIC_DIM.MULT_DOC_IND AS INT64) = 0 THEN 'A/P Master'
            WHEN CMPLY_GLM_LIC_DIM.GLM_ACTV_CLASS_CD = 2
            AND CAST(CMPLY_GLM_LIC_DIM.MULT_DOC_IND AS INT64) = 1 THEN 'A/P Multiple Normal'
            WHEN CMPLY_GLM_LIC_DIM.GLM_ACTV_CLASS_CD = 1
            AND CAST(CMPLY_GLM_LIC_DIM.MULT_DOC_IND AS INT64) = 1 THEN 'A/P Multiple Business'
            ELSE ''
        END
        ELSE ''
    END AS a_p_ind,
    CMPLY_GLM_LIC_DIM.CNTRY_CD AS cntry_cd,
    CASE
        CMPLY_GLM_LIC_DIM.CNTRY_CD
        WHEN 'K1' THEN 'CAM'
        WHEN 'K2' THEN 'CL'
        WHEN 'CL' THEN 'CL(Dept)'
        WHEN 'GB' THEN 'UK'
        WHEN 'K3' THEN 'AF'
        WHEN 'ZA' THEN 'AF'
        ELSE CMPLY_GLM_LIC_DIM.CNTRY_CD
    END AS market,
    GLM_MILESTONE_D_VW.CURR_GLM_MILESTONE_CD AS curr_glm_milestone_cd,
    GLM_MILESTONE_D_VW.CURRENT_MILESTONE_IND AS current_milestone_ind,
    GLM_MILESTONE_D_VW.GLM_MLSTN_CD_5_COMPLETE_IND AS glm_mlstn_cd_5_complete_ind,
    TRIM(GLM_LICENSE_STATUS_TXT.GLM_LIC_STATUS_DESC) AS glm_lic_status_desc,
    CASE
        GLM_MILESTONE_D_VW.LANG_CD
        WHEN '101' THEN 'English'
        WHEN '106' THEN 'Spanish'
        WHEN '105' THEN 'Portuguese'
        WHEN '141' THEN 'Spanish'
        WHEN '102' THEN 'Spanish'
        WHEN '136' THEN 'Spanish'
        WHEN '103' THEN 'French'
        WHEN '114' THEN 'English'
        WHEN '147' THEN 'English'
        WHEN '117' THEN 'English'
        WHEN '127' THEN 'Japanese'
        WHEN '107' THEN 'Mandarin'
        WHEN '128' THEN 'Spanish'
        WHEN '201' THEN 'English'
        ELSE 'English'
    END AS lang_desc,
    GLM_MILESTONE_D_VW.LANG_CD AS lang_cd
FROM
    `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_glm_lic_dim CMPLY_GLM_LIC_DIM
    JOIN `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_milestone_d_vw_v3 GLM_MILESTONE_D_VW ON CMPLY_GLM_LIC_DIM.LIC_SK_ID = GLM_MILESTONE_D_VW.LIC_SK_ID
    AND CMPLY_GLM_LIC_DIM.CNTRY_CD = GLM_MILESTONE_D_VW.CNTRY_CD
    JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_glm_lic_status_txt GLM_LICENSE_STATUS_TXT ON CMPLY_GLM_LIC_DIM.GLM_LIC_STATUS_CD = GLM_LICENSE_STATUS_TXT.GLM_LIC_STATUS_CD
    AND CMPLY_GLM_LIC_DIM.CNTRY_CD = GLM_LICENSE_STATUS_TXT.CNTRY_CD
    AND GLM_MILESTONE_D_VW.LANG_CD = GLM_LICENSE_STATUS_TXT.LANG_CD;

-- LP_METRICS : PK : LIC_SK_ID, BU_SK_ID, GLM_APPLN_TYPE_CD, GLM_LIC_CLASS_CD, GLM_LIC_CATG_CD, LIC_TYPE_CD, LANG_CD, CNTRY_CD (Multiple Languages)
create
or replace table `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_lp_metrics_vw_v2 AS
SELECT
    CMPLY_GLM_LIC_DIM.LIC_SK_ID AS lic_sk_id,
    CMPLY_GLM_LIC_DIM.GLM_LIC_APPLN_ID AS glm_lic_appln_id,
    COALESCE(CMPLY_GLM_LIC_DIM.ASSGN_GLM_USERID, '') AS assgn_glm_userid,
    CMPLY_GLM_LIC_DIM.GLM_LIC_STATUS_CD as glm_license_status_cd,
    CMPLY_GLM_LIC_DIM.START_DT as start_date,
    CMPLY_GLM_LIC_DIM.CPLT_BY_USERID as completed_by_userid,
    CMPLY_GLM_LIC_DIM.EXP_DT AS exp_dt,
    CMPLY_GLM_LIC_DIM.CMPLT_DT as complete_date,
    CMPLY_GLM_LIC_DIM.CREATE_DT as create_date,
    TRIM(CMPLY_GLM_LIC_DIM.LIC_ACTV_DESC) as lic_actv_desc,
    CMPLY_GLM_LIC_DIM.GLM_ACTV_CLASS_CD AS glm_actv_class_cd,
    TRIM(CMPLY_GLM_LIC_DIM.GLM_ACTV_CLASS_DESC) AS glm_actv_class_desc,
    CAST(CMPLY_GLM_LIC_DIM.MULT_DOC_IND AS INT64) AS mult_doc_ind,
    CMPLY_GLM_LIC_DIM.EFF_TS as effective_ts,
    CAST(CMPLY_GLM_LIC_DIM.PENDG_LIC_ALERT_IND AS INT) as pending_license_alert_ind,
    CMPLY_GLM_LIC_DIM.PENDG_LIC_ALERT_DT as pending_license_alert_date,
    CMPLY_GLM_LIC_DIM.BUSCON_IMPACTED AS buscon_impacted,
    CMPLY_GLM_LIC_DIM.BUSCON_IMPACTED_RSN_CD as buscon_imp_rsn_cd,
    CMPLY_GLM_LIC_DIM.BUSCON_END_DT_PVD as buscon_end_date_pvd,
    CMPLY_GLM_LIC_DIM.BUSCON_END_DT as buscon_end_date,
    TRIM(CMPLY_GLM_LIC_DIM.BUSCON_IMPACTED_RSN_DESC) as buscon_imp_rsn_desc,
    CMPLY_GLM_LIC_DIM.GOVT_AGCY_TYPE_CD AS govt_agcy_type_cd,
    -- TRIM(CMPLY_GLM_LIC_DIM.LIC_NOT_REQD_RSN_TXT) as license_not_req_rsn_txt,
    COALESCE(LICENSE_NOT_REQ_REQUEST.NOT_REQD_RSN_DESC, '') AS license_not_req_rsn_txt,
    CMPLY_GLM_LIC_DIM.CNTRY_CD AS cntry_cd,
    GLM_LICENSE_F_VW.MARKET AS market,
    GLM_LICENSE_F_VW.TIME_RANGE AS time_range,
    GLM_LICENSE_F_VW.EXPIRATION_TIME_RANGE AS expiration_time_range,
    GLM_LICENSE_F_VW.SERIAL_NO AS serial_no,
    GLM_LICENSE_F_VW.VALID_IND AS valid_ind,
    GLM_LICENSE_F_VW.NEW_IND AS new_ind,
    GLM_LICENSE_F_VW.NEW_FACILITY_IND AS new_facility_ind,
    GLM_LICENSE_F_VW.LICENSE_IND AS license_ind,
    GLM_LICENSE_F_VW.PE_IND AS pe_ind,
    GLM_LICENSE_F_VW.PI_IND AS pi_ind,
    GLM_LICENSE_F_VW.A_P_IND AS a_p_ind,
    GLM_LICENSE_F_VW.LANG_DESC AS lang_desc,
    GLM_LICENSE_F_VW.LANG_CD AS lang_cd,
    GLM_LICENSE_F_VW.GLM_LIC_STATUS_DESC AS glm_lic_status_desc,
    COUNT(DISTINCT CMPLY_GLM_LIC_BU.BU_SK_ID) OVER(PARTITION BY CMPLY_GLM_LIC_DIM.LIC_SK_ID) AS activity_count,
    CMPLY_GLM_LIC_BU.BU_SK_ID AS bu_sk_id,
    CMPLY_GLM_LIC_BU.STATE AS state,
    CMPLY_GLM_LIC_BU.CITY AS city,
    CMPLY_GLM_LIC_BU.BUSINESS_TYPE_DESC AS business_type_desc,
    CMPLY_GLM_LIC_BU.SUBDIV_NBR AS subdiv_nbr,
    CMPLY_GLM_LIC_BU.BANNER_DESCRIPTION AS banner_description,
    CMPLY_GLM_LIC_BU.STORE_NBR AS store_nbr,
    CMPLY_GLM_LIC_BU.OPEN_DATE AS open_date,
    CMPLY_GLM_LIC_BU.OPEN_STATUS_DESC AS open_status_desc,
    CMPLY_GLM_LIC_BU.FUTURE_STORES AS future_stores,
    GLM_LICENSE_TYPE_D_VW.GLM_APPLN_TYPE_CD AS glm_appln_type_cd,
    GLM_LICENSE_TYPE_D_VW.GLM_LIC_CLASS_CD AS glm_lic_class_cd,
    GLM_LICENSE_TYPE_D_VW.GLM_LIC_CATG_CD AS glm_lic_catg_cd,
    GLM_LICENSE_TYPE_D_VW.LIC_TYPE_CD AS lic_type_cd,
    GLM_LICENSE_TYPE_D_VW.LIC_TYPE_DESC AS lic_type_desc,
    GLM_LICENSE_TYPE_D_VW.GLM_LIC_CATG_DESC AS glm_lic_catg_desc,
    GLM_LICENSE_TYPE_D_VW.GLM_APPLN_TYPE_DESC AS glm_appln_type_desc,
    GLM_LICENSE_TYPE_D_VW.GLM_LIC_CLASS_DESC AS glm_lic_class_desc,
    GLM_MILESTONE_D_VW.CURR_GLM_MILESTONE_CD AS curr_glm_milestone_cd,
    GLM_MILESTONE_D_VW.curr_milestone_complete_ind AS curr_milestone_complete_ind,
    GLM_MILESTONE_D_VW.CURR_LICENSE_MILESTONE_SEQ_NBR AS curr_license_milestone_seq_nbr,
    GLM_MILESTONE_D_VW.CURRENT_MILESTONE_IND AS current_milestone_ind,
    GLM_MILESTONE_D_VW.CURR_GLM_MLSTN_DESC AS curr_glm_mlstn_desc,
    GLM_MILESTONE_D_VW.GLM_MLSTN_CD_5_COMPLETE_IND AS glm_mlstn_cd_5_complete_ind,
    GLM_MILESTONE_D_VW.GLM_MLSTN_CD_5_LAST_CHG_TS AS glm_mlstn_cd_5_last_chg_ts,
    GLM_MILESTONE_D_VW.CURR_CREATE_TS AS curr_create_ts,
    GLM_MILESTONE_D_VW.CURR_LAST_CHG_TS AS curr_last_chg_ts,
    TRIM(GLM_GOVT_AGNCY_TYPE_TXT.GOVT_AGNCY_TYPE_DESC) AS govt_agncy_type_desc,
FROM
    `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_glm_lic_dim CMPLY_GLM_LIC_DIM
    JOIN `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_lic_bu_f_vw_v1 CMPLY_GLM_LIC_BU ON CMPLY_GLM_LIC_DIM.LIC_SK_ID = CMPLY_GLM_LIC_BU.LIC_SK_ID
    JOIN `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_license_f_vw_v2 GLM_LICENSE_F_VW ON CMPLY_GLM_LIC_DIM.LIC_SK_ID = GLM_LICENSE_F_VW.LIC_SK_ID
    AND CMPLY_GLM_LIC_DIM.CNTRY_CD = GLM_LICENSE_F_VW.CNTRY_CD
    JOIN `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_milestone_d_vw_v3 GLM_MILESTONE_D_VW ON CMPLY_GLM_LIC_DIM.LIC_SK_ID = GLM_MILESTONE_D_VW.LIC_SK_ID
    AND CMPLY_GLM_LIC_DIM.CNTRY_CD = GLM_MILESTONE_D_VW.CNTRY_CD
    AND GLM_LICENSE_F_VW.LANG_CD = GLM_MILESTONE_D_VW.LANG_CD
    JOIN `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_license_type_d_vw_v2 GLM_LICENSE_TYPE_D_VW ON CMPLY_GLM_LIC_DIM.LIC_SK_ID = GLM_LICENSE_TYPE_D_VW.LIC_SK_ID
    AND CMPLY_GLM_LIC_DIM.CNTRY_CD = GLM_LICENSE_TYPE_D_VW.CNTRY_CD
    AND GLM_LICENSE_F_VW.LANG_CD = GLM_LICENSE_TYPE_D_VW.LANG_CD
    JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_glm_govt_agcy_type_txt GLM_GOVT_AGNCY_TYPE_TXT ON CMPLY_GLM_LIC_DIM.GOVT_AGCY_TYPE_CD = GLM_GOVT_AGNCY_TYPE_TXT.GOVT_AGCY_TYPE_CD
    AND CMPLY_GLM_LIC_DIM.CNTRY_CD = GLM_GOVT_AGNCY_TYPE_TXT.CNTRY_CD
    AND GLM_LICENSE_F_VW.LANG_CD = GLM_GOVT_AGNCY_TYPE_TXT.LANG_CD
    LEFT OUTER JOIN `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_license_not_req_request_vw_v1 LICENSE_NOT_REQ_REQUEST ON CMPLY_GLM_LIC_DIM.LIC_SK_ID = LICENSE_NOT_REQ_REQUEST.LIC_SK_ID
    AND CMPLY_GLM_LIC_DIM.CNTRY_CD = LICENSE_NOT_REQ_REQUEST.CNTRY_CD
    AND GLM_LICENSE_F_VW.LANG_CD = LICENSE_NOT_REQ_REQUEST.LANG_CD
WHERE
    CMPLY_GLM_LIC_BU.MARKET NOT IN ('AR', 'JP', 'UK', 'BR')
    AND GLM_LICENSE_F_VW.LANG_CD NOT IN ('103');

-- REPORTING - Status Tracking (International Application Type) - PK : LIC_SK_ID, BU_SK_ID, GLM_APPLN_TYPE_CD, GLM_LIC_CLASS_CD, GLM_LIC_CATG_CD, LIC_TYPE_CD, LANG_CD, CNTRY_CD (Multiple Languages)
CREATE
OR REPLACE VIEW `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_status_tracking_licenses_vw AS
SELECT
    LP_METRICS.LIC_SK_ID AS lic_sk_id,
    LP_METRICS.MARKET AS market,
    LP_METRICS.CNTRY_CD AS country_code,
    LP_METRICS.STORE_NBR AS store_nbr,
    -- LP_METRICS.GLM_APPLN_TYPE_CD AS glm_appln_type_cd,
    -- LP_METRICS.GLM_LIC_CLASS_CD AS glm_lic_class_cd,
    -- LP_METRICS.GLM_LIC_CATG_CD AS glm_lic_catg_cd,
    -- LP_METRICS.LIC_TYPE_CD AS lic_type_cd,
    LP_METRICS.LIC_TYPE_DESC AS license_type_desc,
    LP_METRICS.GLM_LIC_CATG_DESC AS glm_license_catg_desc,
    LP_METRICS.GLM_APPLN_TYPE_DESC AS glm_appln_type_desc,
    -- LP_METRICS.GLM_LIC_CLASS_DESC AS glm_lic_class_desc,
    LP_METRICS.LIC_ACTV_DESC AS lic_actv_desc,
    LP_METRICS.TIME_RANGE AS time_range,
    LP_METRICS.SERIAL_NO AS serial_no,
    LP_METRICS.VALID_IND AS valid_ind,
    LP_METRICS.PE_IND AS pe_ind,
    LP_METRICS.PI_IND AS pi_ind,
    LP_METRICS.A_P_IND AS a_p_ind,
    LP_METRICS.LICENSE_IND AS license_ind,
    LP_METRICS.LANG_CD AS lang_cd,
    LP_METRICS.LANG_DESC AS language_desc,
    LP_METRICS.GLM_LICENSE_STATUS_CD AS glm_license_status_cd,
    -- LP_METRICS.GLM_LIC_STATUS_DESC AS glm_lic_status_desc,
    LP_METRICS.ASSGN_GLM_USERID AS assigned_glm_userid,
    LP_METRICS.GLM_LIC_APPLN_ID AS glm_license_app_id,
    LP_METRICS.EXP_DT AS expiration_dt,
    LP_METRICS.CREATE_DATE AS calendar_date,
    LP_METRICS.COMPLETE_DATE AS complete_date,
    DATE_DIFF(CURRENT_TIMESTAMP, LP_METRICS.EXP_DT, DAY) as exp_dt,
    LP_METRICS.CURR_GLM_MLSTN_DESC AS glm_milestone_desc,
    LP_METRICS.CURRENT_MILESTONE_IND AS current_milestone_ind,
    LP_METRICS.CURR_GLM_MILESTONE_CD AS curr_glm_milestone_cd,
    -- LP_METRICS.CURR_MILESTONE_COMPLETE_IND AS curr_milestone_complete_ind,
    -- LP_METRICS.GLM_MLSTN_CD_5_COMPLETE_IND AS glm_mlstn_cd_5_complete_ind,
    -- LP_METRICS.GLM_MLSTN_CD_5_LAST_CHG_TS AS glm_mlstn_cd_5_last_chg_ts
FROM
    `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_lp_metrics_vw_v2 LP_METRICS;

CREATE
OR REPLACE TABLE `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_status_tracking_licenses AS
SELECT
    *
FROM
    `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_status_tracking_licenses_vw;

-- REPORTING - Status Tracking (International) : PK : LIC_SK_ID, TASK_SK_ID, LANG_CD
create
or replace view `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_status_tracking_tasks_vw as
select
    LP_METRICS.LIC_SK_ID AS lic_sk_id,
    LP_METRICS.MARKET AS market,
    lp_metrics.CNTRY_CD as country_code,
    -- LP_METRICS.GLM_APPLN_TYPE_CD AS glm_appln_type_cd,
    -- LP_METRICS.GLM_LIC_CLASS_CD AS glm_lic_class_cd,
    -- LP_METRICS.GLM_LIC_CATG_CD AS glm_lic_catg_cd,
    -- LP_METRICS.LIC_TYPE_CD AS lic_type_cd,
    LP_METRICS.LIC_TYPE_DESC AS license_type_desc,
    LP_METRICS.GLM_LIC_CATG_DESC AS glm_license_catg_desc,
    LP_METRICS.GLM_APPLN_TYPE_DESC AS glm_appln_type_desc,
    -- LP_METRICS.GLM_LIC_CLASS_DESC AS glm_lic_class_desc,
    LP_METRICS.BUSINESS_TYPE_DESC as business_type_desc,
    LP_METRICS.LIC_ACTV_DESC as license_activity_desc,
    LP_METRICS.SUBDIV_NBR as subdiv_nbr,
    LP_METRICS.STORE_NBR as store_nbr,
    LP_METRICS.TIME_RANGE AS time_range,
    LP_METRICS.SERIAL_NO AS serial_no,
    LP_METRICS.VALID_IND AS valid_ind,
    LP_METRICS.PE_IND AS pe_ind,
    LP_METRICS.PI_IND AS pi_ind,
    LP_METRICS.A_P_IND AS a_p_ind,
    LP_METRICS.LICENSE_IND AS license_ind,
    LP_METRICS.LANG_CD as lang_cd,
    LP_METRICS.LANG_DESC as language_desc,
    LP_METRICS.GLM_LICENSE_STATUS_CD as glm_license_status_cd,
    LP_METRICS.GLM_LIC_STATUS_DESC as glm_lic_status_desc,
    LP_METRICS.LICENSE_NOT_REQ_RSN_TXT as license_not_req_rsn_txt,
    LP_METRICS.ASSGN_GLM_USERID as assigned_glm_userid,
    LP_METRICS.GLM_LIC_APPLN_ID as glm_license_app_id,
    LP_METRICS.EXP_DT as expiration_dt,
    LP_METRICS.CURR_GLM_MILESTONE_CD AS curr_glm_milestone_cd,
    LP_METRICS.START_DATE as start_date,
    date_diff(current_timestamp, LP_METRICS.EXP_DT, day) as exp_dt,
    LP_METRICS.CREATE_DATE as calendar_date,
    format_date("%b", LP_METRICS.CREATE_DATE) as cal_month_abbr,
    concat(
        "Week ",
        cast(
            format_date("%U", LP_METRICS.CREATE_DATE) as string
        )
    ) as cal_week_nbr_txt,
    extract(
        year
        from
            cast(LP_METRICS.CREATE_DATE as date)
    ) as cal_year_nbr,
    LP_METRICS.COMPLETE_DATE as complete_date,
    LP_METRICS.GLM_MLSTN_CD_5_COMPLETE_IND as glm_mlstn_cd_5_complete_ind,
    CASE
        WHEN LP_METRICS.GLM_MLSTN_CD_5_COMPLETE_IND = 1 THEN 'Submitted'
        WHEN LP_METRICS.CURR_GLM_MILESTONE_CD = 2 THEN 'Submitted'
        ELSE 'Not Submitted'
    END AS glm_milestone_desc_lic_sub,
    GLM_TASK_DIM_F_VW.CREATE_TS as create_ts,
    GLM_TASK_DIM_F_VW.LAST_CHNG_TS as last_chg_ts,
    GLM_TASK_DIM_F_VW.glm_mlstn_cd as glm_milestone_cd,
    GLM_TASK_DIM_F_VW.glm_mlstn_desc as glm_milestone_desc,
    GLM_TASK_DIM_F_VW.curr_mlstn_ind as current_milestone_ind,
    GLM_TASK_DIM_F_VW.mlstn_cmplt_ind as mlstn_cmplt_ind,
    coalesce(GLM_TASK_DIM_F_VW.task_sk_id, 0) as task_sk_id,
    coalesce(GLM_TASK_DIM_F_VW.task_seq_nbr, 0) as task_seq_nbr,
    coalesce(
        glm_task_dim_f_vw.last_chng_ts,
        cast(parse_datetime("%F", "1970-01-01") as timestamp)
    ) as ms_last_chg_ts,
    coalesce(glm_task_dim_f_vw.task_nm, '') as task_nm,
    glm_task_dim_f_vw.glm_task_id AS glm_task_id
from
    `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_lp_metrics_vw_v2 lp_metrics
    left outer join (
        select
            task_sk_id,
            glm_task_id,
            task_seq_nbr,
            last_chng_ts,
            task_nm,
            lic_sk_id,
            glm_mlstn_cd,
            glm_mlstn_desc,
            curr_mlstn_ind,
            cntry_cd,
            mlstn_cmplt_ind,
            lang_cd,
            create_ts
        from
            `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_task_dim_f_vw_v2
        where
            task_seq_nbr not in (
                200,
                400,
                600,
                800,
                1000,
                1200,
                1400,
                1600,
                1800,
                2000,
                2200,
                2400,
                2600,
                2800
            ) -- and curr_glm_milestone_cd != 0
    ) glm_task_dim_f_vw on lp_metrics.lic_sk_id = glm_task_dim_f_vw.lic_sk_id
    and lp_metrics.lang_cd = glm_task_dim_f_vw.lang_cd
    and lp_metrics.cntry_cd = glm_task_dim_f_vw.cntry_cd;

create
or replace table `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_status_tracking_tasks as
select
    *
from
    `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_status_tracking_tasks_vw;

-- REPORTING - Status Tracking (Licenses Not Required) : PK : LIC_SK_ID, TASK_SK_ID, LANG_CD
create
or replace view `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_status_tracking_lic_not_req_vw as
select
    lp_metrics.lic_sk_id as lic_sk_id,
    lp_metrics.market as market,
    lp_metrics.cntry_cd as cntry_cd,
    lp_metrics.business_type_desc as business_type_desc,
    lp_metrics.store_nbr as store_nbr,
    lp_metrics.glm_appln_type_desc as glm_appln_type_desc,
    lp_metrics.license_ind AS license_ind,
    lp_metrics.lang_cd as lang_cd,
    lp_metrics.lang_desc as lang_desc,
    lp_metrics.glm_license_status_cd as glm_license_status_cd,
    lp_metrics.glm_lic_status_desc as glm_lic_status_desc,
    lp_metrics.license_not_req_rsn_txt as license_not_req_rsn_txt,
    lp_metrics.assgn_glm_userid as assigned_glm_userid,
    lp_metrics.glm_lic_appln_id as glm_license_app_id,
    lp_metrics.start_date as start_date,
    lp_metrics.complete_date AS complete_date,
    lp_metrics.lic_actv_desc as lic_actv_desc,
    lp_metrics.lic_type_desc as lic_type_desc,
    lp_metrics.glm_lic_catg_desc as glm_lic_catg_desc,
    COALESCE(LICENSE_NOT_REQ_REQUEST.RQSTR_USERID, '') AS rqstr_userid,
    COALESCE(LICENSE_NOT_REQ_REQUEST.APPV_USERID, '') AS appv_userid,
    COALESCE(LICENSE_NOT_REQ_REQUEST.APPV_IND, 0) AS appv_ind,
    COALESCE(LICENSE_NOT_REQ_REQUEST.NOT_REQD_RSN_CD, 0) AS not_reqd_rsn_cd,
    COALESCE(LICENSE_NOT_REQ_REQUEST.LAST_CHNG_USERID, '') AS last_chng_userid,
    LICENSE_NOT_REQ_REQUEST.LAST_CHNG_TS AS last_chng_ts,
    COALESCE(LICENSE_NOT_REQ_REQUEST.NOT_REQD_RSN_DESC, '') AS not_reqd_rsn_desc
from
    `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_lp_metrics_vw_v2 lp_metrics
    LEFT OUTER JOIN `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_license_not_req_request_vw_v1 LICENSE_NOT_REQ_REQUEST ON LP_METRICS.lic_sk_id = LICENSE_NOT_REQ_REQUEST.lic_sk_id
    AND LP_METRICS.cntry_cd = LICENSE_NOT_REQ_REQUEST.cntry_cd
    AND LP_METRICS.lang_cd = LICENSE_NOT_REQ_REQUEST.lang_cd
where
    appv_ind = 1
    AND glm_license_status_cd = 5;

CREATE
OR REPLACE TABLE `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_status_tracking_lic_not_req AS
SELECT
    *
FROM
    `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_status_tracking_lic_not_req_vw;

-- REPORTING - Business Continuity - Summary - PK : LIC_SK_ID, BU_SK_ID, GLM_APPLN_TYPE_CD, GLM_LIC_CLASS_CD, GLM_LIC_CATG_CD, LIC_TYPE_CD, LANG_CD, CNTRY_CD (Multiple Languages)
CREATE
OR REPLACE VIEW `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_business_continuity_summary_vw AS
SELECT
    LP_METRICS.LIC_SK_ID AS lic_sk_id,
    LP_METRICS.STORE_NBR AS store_nbr,
    LP_METRICS.GLM_APPLN_TYPE_CD AS glm_appln_type_cd,
    LP_METRICS.GLM_LIC_CLASS_CD AS glm_lic_class_cd,
    LP_METRICS.GLM_LIC_CATG_CD AS glm_lic_catg_cd,
    LP_METRICS.LIC_TYPE_CD AS lic_type_cd,
    LP_METRICS.LIC_TYPE_DESC AS lic_type_desc,
    LP_METRICS.GLM_LIC_CATG_DESC AS glm_lic_catg_desc,
    LP_METRICS.GLM_APPLN_TYPE_DESC AS glm_appln_type_desc,
    LP_METRICS.GLM_LIC_CLASS_DESC AS glm_lic_class_desc,
    LP_METRICS.MARKET AS market,
    LP_METRICS.CNTRY_CD AS country_code,
    LP_METRICS.TIME_RANGE AS time_range,
    LP_METRICS.SERIAL_NO AS serial_no,
    LP_METRICS.VALID_IND AS valid_ind,
    LP_METRICS.PE_IND AS pe_ind,
    LP_METRICS.PI_IND AS pi_ind,
    LP_METRICS.A_P_IND AS a_p_ind,
    LP_METRICS.LANG_CD AS lang_cd,
    LP_METRICS.LANG_DESC AS language_desc,
    LP_METRICS.BUSCON_IMPACTED AS buscon_impacted,
    LP_METRICS.BUSCON_IMP_RSN_CD AS buscon_imp_rsn_cd,
    LP_METRICS.BUSCON_END_DATE AS buscon_end_date,
    LP_METRICS.BUSCON_IMP_RSN_DESC AS buscon_imp_rsn_desc,
    CASE
        WHEN DATE_DIFF(
            DATE(LP_METRICS.buscon_end_date),
            current_date,
            DAY
        ) < 0 THEN "Past_Due"
        WHEN (
            DATE_DIFF(
                DATE(LP_METRICS.buscon_end_date),
                current_date,
                DAY
            ) > 0
            and DATE_DIFF(
                DATE(LP_METRICS.buscon_end_date),
                current_date,
                DAY
            ) <= 7
        ) THEN "0-7 Days"
        WHEN (
            DATE_DIFF(
                DATE(LP_METRICS.buscon_end_date),
                current_date,
                DAY
            ) > 8
            and DATE_DIFF(
                DATE(LP_METRICS.buscon_end_date),
                current_date,
                DAY
            ) <= 15
        ) THEN "8-15 Days"
        WHEN DATE_DIFF(
            DATE(LP_METRICS.buscon_end_date),
            current_date,
            DAY
        ) > 15 THEN "16+Days"
    END as buscon_time_range,
    LP_METRICS.LIC_TYPE_DESC AS license_type_desc,
    LP_METRICS.GLM_LIC_CATG_DESC AS glm_license_catg_desc
FROM
    `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_lp_metrics_vw_v2 LP_METRICS;

CREATE
OR REPLACE TABLE `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_business_continuity_summary AS
SELECT
    *
FROM
    `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_business_continuity_summary_vw;

-- REPORTING - Business Continuity - Drill Down
CREATE
OR REPLACE VIEW `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_business_continuity_detail_vw AS
SELECT
    LP_METRICS.LIC_SK_ID AS lic_sk_id,
    LP_METRICS.MARKET AS market,
    LP_METRICS.STORE_NBR AS store_nbr,
    LP_METRICS.CNTRY_CD AS country_code,
    LP_METRICS.GLM_APPLN_TYPE_DESC AS glm_appln_type_desc,
    LP_METRICS.TIME_RANGE AS time_range,
    LP_METRICS.SERIAL_NO AS serial_no,
    LP_METRICS.VALID_IND AS valid_ind,
    LP_METRICS.PE_IND AS pe_ind,
    LP_METRICS.PI_IND AS pi_ind,
    LP_METRICS.A_P_IND AS a_p_ind,
    LP_METRICS.LANG_CD AS lang_cd,
    LP_METRICS.LANG_DESC AS language_desc,
    LP_METRICS.BUSCON_IMPACTED AS buscon_impacted,
    LP_METRICS.BUSCON_IMP_RSN_CD AS buscon_imp_rsn_cd,
    LP_METRICS.BUSCON_END_DATE AS buscon_end_date,
    LP_METRICS.BUSCON_IMP_RSN_DESC AS buscon_imp_rsn_desc,
    CASE
        WHEN DATE_DIFF(
            DATE(LP_METRICS.buscon_end_date),
            current_date,
            DAY
        ) < 0 THEN "Past_Due"
        WHEN (
            DATE_DIFF(
                DATE(LP_METRICS.buscon_end_date),
                current_date,
                DAY
            ) > 0
            AND DATE_DIFF(
                DATE(LP_METRICS.buscon_end_date),
                current_date,
                DAY
            ) <= 7
        ) THEN "0-7 Days"
        WHEN (
            DATE_DIFF(
                DATE(LP_METRICS.buscon_end_date),
                current_date,
                DAY
            ) > 8
            AND DATE_DIFF(
                DATE(LP_METRICS.buscon_end_date),
                current_date,
                DAY
            ) <= 15
        ) THEN "8-15 Days"
        WHEN DATE_DIFF(
            DATE(LP_METRICS.buscon_end_date),
            current_date,
            DAY
        ) > 15 THEN "16+Days"
    END as buscon_time_range,
    LP_METRICS.ASSGN_GLM_USERID AS assigned_glm_userid,
    LP_METRICS.GLM_LIC_APPLN_ID AS glm_license_app_id,
    LP_METRICS.EXP_DT AS expiration_date,
    DATE_DIFF(CURRENT_TIMESTAMP, LP_METRICS.EXP_DT, DAY) as exp_dt,
    LP_METRICS.GOVT_AGNCY_TYPE_DESC AS govt_agncy_type_desc,
    LP_METRICS.CURRENT_MILESTONE_IND AS current_milestone_ind,
    LP_METRICS.CURR_GLM_MLSTN_DESC AS glm_milestone_desc,
    LP_METRICS.LIC_TYPE_DESC AS license_type_desc,
    LP_METRICS.GLM_LIC_CATG_DESC AS glm_license_catg_desc,
    COALESCE(GLM_CONTACT_F_VW.GLM_CNTCT_LINE3, '') AS glm_cntct_line3
FROM
    `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_lp_metrics_vw_v2 LP_METRICS
    LEFT OUTER JOIN `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_contact_f_vw_v1 GLM_CONTACT_F_VW ON LP_METRICS.GLM_LIC_APPLN_ID = GLM_CONTACT_F_VW.GLM_LIC_APPLN_ID
    AND LP_METRICS.CNTRY_CD = GLM_CONTACT_F_VW.CNTRY_CD
    AND LP_METRICS.LANG_CD = GLM_CONTACT_F_VW.LANG_CD;

CREATE
OR REPLACE TABLE `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_business_continuity_detail AS
SELECT
    *
FROM
    `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_business_continuity_detail_vw;

-- REPORTING - TPI Summary
CREATE
OR REPLACE VIEW `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_tpi_summary_vw AS
SELECT
    GLM_TPI.TPI_ID AS tpi_id,
    CASE
        WHEN TRIM(GLM_TPI.ACTV) = 'Y' THEN 1
        ELSE 0
    END as active,
    CASE
        WHEN TRIM(GLM_TPI.ACTV) = 'Y' THEN 0
        ELSE 1
    END as inactive,
    TRIM(GLM_TPI.ACTV) AS actv,
    TRIM(GLM_TPI.ENTY_NM) AS tpi_name,
    GLM_TPI.ENTY_ID AS enty_id,
    LP_METRICS.MARKET as market,
    LP_METRICS.LIC_SK_ID AS lic_sk_id,
    LP_METRICS.PI_IND AS pi_ind,
    LP_METRICS.PE_IND AS pe_ind,
    LP_METRICS.VALID_IND AS valid_ind,
    LP_METRICS.LICENSE_IND AS license_ind,
    LP_METRICS.LANG_DESC AS lang_desc,
    LP_METRICS.LANG_CD AS lang_cd,
    LP_METRICS.LIC_TYPE_DESC AS lic_type_desc,
    LP_METRICS.GLM_LIC_STATUS_DESC AS glm_lic_status_desc,
    LP_METRICS.GLM_LIC_APPLN_ID AS glm_lic_appln_id,
    LP_METRICS.STORE_NBR AS store_nbr,
    CASE
        WHEN LP_METRICS.GLM_MLSTN_CD_5_COMPLETE_IND = 1 THEN 'Submitted'
        WHEN LP_METRICS.CURR_GLM_MILESTONE_CD = 2 THEN 'Submitted'
        ELSE 'Not Submitted'
    END AS glm_milestone_desc
FROM
    `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_lp_metrics_vw_v2 LP_METRICS
    JOIN `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_contact_f_vw_v1 GLM_CONTACT_F_VW ON LP_METRICS.GLM_LIC_APPLN_ID = GLM_CONTACT_F_VW.GLM_LIC_APPLN_ID
    AND LP_METRICS.CNTRY_CD = GLM_CONTACT_F_VW.CNTRY_CD
    AND LP_METRICS.LANG_CD = GLM_CONTACT_F_VW.LANG_CD
    JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_glm_tpi GLM_TPI ON GLM_CONTACT_F_VW.CNTRY_CD = GLM_TPI.CNTRY_CD
    AND GLM_CONTACT_F_VW.GLM_CNTCT_LINE4 = TRIM(GLM_TPI.TPI_ID);

CREATE
OR REPLACE TABLE `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_tpi_summary AS
SELECT
    *
FROM
    `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_tpi_summary_vw;

-- REPORTING - TPI Drill Down
CREATE
OR REPLACE VIEW `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_tpi_detail_vw AS
SELECT
    LP_METRICS.LIC_SK_ID AS lic_sk_id,
    LP_METRICS.PI_IND AS pi_ind,
    LP_METRICS.PE_IND AS pe_ind,
    LP_METRICS.VALID_IND AS valid_ind,
    LP_METRICS.LICENSE_IND AS license_ind,
    LP_METRICS.LANG_DESC AS lang_desc,
    LP_METRICS.LANG_CD AS lang_cd,
    LP_METRICS.LIC_TYPE_DESC AS lic_type_desc,
    LP_METRICS.GLM_LIC_STATUS_DESC AS glm_lic_status_desc,
    LP_METRICS.GLM_LIC_APPLN_ID AS glm_license_app_id,
    LP_METRICS.EXP_DT AS exp_dt,
    LP_METRICS.CURR_GLM_MLSTN_DESC AS current_glm_mlstn_desc_orig,
    LP_METRICS.CURRENT_MILESTONE_IND AS current_milestone_ind,
    LP_METRICS.STORE_NBR as store_nbr,
    GLM_TPI.TPI_ID AS tpi_id,
    CASE
        WHEN GLM_TPI.ACTV = 'Y' THEN 1
        ELSE 0
    END as active,
    CASE
        WHEN GLM_TPI.ACTV = 'Y' THEN 0
        ELSE 1
    END as inactive,
    GLM_TPI.ENTY_ID AS enty_id,
    TRIM(GLM_TPI.ENTY_NM) AS tpi_name,
    LP_METRICS.MARKET as market,
    LP_METRICS.CNTRY_CD AS cntry_cd,
    GLM_TASK_DIM_F_VW.TASK_PRE_REQ_DUE_TS AS alert_date,
    GLM_TASK_DIM_F_VW.TASK_PRE_REQ_RSN_CD AS task_pre_req_rsn_cd,
    GLM_TASK_DIM_F_VW.TASK_PRE_REQ_AREA_CD AS task_pre_req_area_cd,
    GLM_TASK_DIM_F_VW.TASK_PRE_REQ_RSN_DESC AS who_is_needed,
    GLM_TASK_DIM_F_VW.TASK_PRE_REQ_AREA_DESC AS who_is_responsible,
    CASE
        WHEN GLM_TASK_DIM_F_VW.GLM_MLSTN_CD = 5
        AND GLM_TASK_DIM_F_VW.MLSTN_CMPLT_IND = 1 THEN 'Submitted'
        WHEN GLM_TASK_DIM_F_VW.GLM_MLSTN_CD = 2 THEN 'Submitted'
        ELSE 'Not Submitted'
    END AS glm_milestone_desc,
    '' AS submission_due_date,
    GLM_CONTACT_F_VW.GLM_CNTCT_ID AS glm_cntct_id,
    CASE
        ROW_NUMBER() OVER(
            PARTITION BY LP_METRICS.LIC_SK_ID,
            LP_METRICS.LANG_CD,
            LP_METRICS.CNTRY_CD,
            GLM_TPI.TPI_ID,
            GLM_TPI.ACTV
        )
        WHEN 1 THEN 1
        ELSE 0
    END AS summary_row_ind
FROM
    `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_lp_metrics_vw_v2 LP_METRICS
    JOIN `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_contact_f_vw_v1 GLM_CONTACT_F_VW ON LP_METRICS.GLM_LIC_APPLN_ID = GLM_CONTACT_F_VW.GLM_LIC_APPLN_ID
    AND LP_METRICS.CNTRY_CD = GLM_CONTACT_F_VW.CNTRY_CD
    AND LP_METRICS.LANG_CD = GLM_CONTACT_F_VW.LANG_CD
    JOIN `wmt-ww-gg-gec-prod`.ww_glbl_gvrnce_dl_tables.hist_cmply_glm_tpi GLM_TPI ON GLM_CONTACT_F_VW.CNTRY_CD = GLM_TPI.CNTRY_CD
    AND GLM_CONTACT_F_VW.GLM_CNTCT_LINE4 = TRIM(GLM_TPI.TPI_ID)
    JOIN `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_task_dim_f_vw_v2 GLM_TASK_DIM_F_VW ON LP_METRICS.LIC_SK_ID = GLM_TASK_DIM_F_VW.LIC_SK_ID
    AND LP_METRICS.CNTRY_CD = GLM_TASK_DIM_F_VW.CNTRY_CD
    AND LP_METRICS.LANG_CD = GLM_TASK_DIM_F_VW.LANG_CD;

CREATE
OR REPLACE TABLE `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_tpi_detail AS
SELECT
    *
FROM
    `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_tpi_detail_vw;

-- REPORTING - Alert Aggregation
CREATE
OR REPLACE VIEW `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.glm_alert_agg_vw AS
SELECT
    LP_METRICS.MARKET as market,
    LP_METRICS.STORE_NBR as facility,
    LP_METRICS.cntry_cd as country_code,
    LP_METRICS.STATE as state,
    LP_METRICS.CITY as city,
    LP_METRICS.LIC_SK_ID AS license_sk_id,
    LP_METRICS.GLM_LIC_APPLN_ID as license_app_id,
    LP_METRICS.ASSGN_GLM_USERID as assigned_user_id,
    LP_METRICS.GLM_APPLN_TYPE_DESC as application_type,
    LP_METRICS.GLM_LIC_CLASS_DESC as license_class,
    LP_METRICS.GLM_LIC_CATG_DESC as license_category,
    LP_METRICS.LIC_TYPE_DESC as license_type,
    LP_METRICS.GOVT_AGNCY_TYPE_DESC as agency_type,
    LP_METRICS.EXP_DT as expiration_date,
    LP_METRICS.PENDING_LICENSE_ALERT_IND AS pending_license_alert_ind,
    LP_METRICS.GLM_LICENSE_STATUS_CD AS license_status_cd,
    LP_METRICS.GLM_LIC_STATUS_DESC as license_status,
    CASE
        WHEN LP_METRICS.MULT_DOC_IND = 0 THEN 'Master'
        WHEN LP_METRICS.MULT_DOC_IND = 1 THEN 'Multiple'
    END AS class_type,
    CASE
        WHEN LP_METRICS.PENDING_LICENSE_ALERT_IND = 1 THEN 'Alerts'
    END AS alert_status,
    LP_METRICS.LANG_CD as language_code,
    LP_METRICS.LANG_DESC as language,
    LP_METRICS.LIC_ACTV_DESC as license_activity_desc,
    LP_METRICS.LIC_ACTV_DESC AS activity_type,
    LP_METRICS.GLM_ACTV_CLASS_DESC AS activity_class,
    LP_METRICS.EXPIRATION_TIME_RANGE AS expiration_time_range,
    LP_METRICS.activity_count AS activity_count,
    CASE
        WHEN LP_METRICS.MULT_DOC_IND = 0 THEN 'Master'
        WHEN LP_METRICS.MULT_DOC_IND = 1 THEN 'Multiple'
    END AS activity_class_type,
    CASE
        WHEN LP_METRICS.CURR_GLM_MILESTONE_CD = 5
        AND LP_METRICS.CURRENT_MILESTONE_IND = 1
        AND LP_METRICS.CURR_MILESTONE_COMPLETE_IND = 1 THEN (
            CASE
                WHEN LP_METRICS.LANG_CD IN ('102', '128', '136', '141') THEN 'Enviado'
                ELSE 'Submitted'
            END
        )
        WHEN LP_METRICS.CURR_GLM_MILESTONE_CD = 2 THEN (
            CASE
                WHEN LP_METRICS.LANG_CD IN ('102', '128', '136', '141') THEN 'Enviado'
                ELSE 'Submitted'
            END
        )
        ELSE (
            CASE
                WHEN LP_METRICS.LANG_CD IN ('102', '128', '136', '141') THEN 'No Presentado'
                ELSE 'Not Submitted'
            END
        )
    END AS submission_status,
    LP_METRICS.LICENSE_IND AS license_ind,
    IF(
        ROW_NUMBER() OVER(
            PARTITION BY LP_METRICS.LIC_SK_ID,
            LP_METRICS.BU_SK_ID,
            LP_METRICS.GLM_APPLN_TYPE_CD,
            LP_METRICS.GLM_LIC_CLASS_CD,
            LP_METRICS.GLM_LIC_CATG_CD,
            LP_METRICS.LIC_TYPE_CD,
            LP_METRICS.LANG_CD,
            LP_METRICS.CNTRY_CD
        ) = 1,
        1,
        0
    ) AS summary_ind,
    CASE
        WHEN LP_METRICS.PENDING_LICENSE_ALERT_IND = 0 THEN ('No Alerts')
        WHEN (
            LP_METRICS.PENDING_LICENSE_ALERT_IND = 1
            and DATE_DIFF(
                GLM_TASK_DIM_F_VW.TASK_PRE_REQ_DUE_TS,
                CURRENT_DATE,
                DAY
            ) < 0
        ) THEN ('Pending Alerts with Past Due Date')
        WHEN (
            LP_METRICS.PENDING_LICENSE_ALERT_IND = 1
            and DATE_DIFF(
                GLM_TASK_DIM_F_VW.TASK_PRE_REQ_DUE_TS,
                CURRENT_DATE,
                DAY
            ) > 0
            and DATE_DIFF(
                GLM_TASK_DIM_F_VW.TASK_PRE_REQ_DUE_TS,
                CURRENT_DATE,
                DAY
            ) <= 7
        ) THEN (
            'Pending Alerts with Due Date Between 0 and 7 Days'
        )
        WHEN (
            LP_METRICS.PENDING_LICENSE_ALERT_IND = 1
            and DATE_DIFF(
                GLM_TASK_DIM_F_VW.TASK_PRE_REQ_DUE_TS,
                CURRENT_DATE,
                DAY
            ) > 7
        ) THEN ('Pending Alerts with Due Date >7 Days')
    END as indicator,
    GLM_TASK_DIM_F_VW.CURR_MLSTN_IND AS current_milestone_ind,
    GLM_TASK_DIM_F_VW.GLM_MLSTN_DESC AS milestone_desc,
    GLM_TASK_DIM_F_VW.TASK_PRE_REQ_DUE_TS AS task_pre_req_due_ts,
    GLM_TASK_DIM_F_VW.TASK_PRE_REQ_DUE_TS as due_date,
    GLM_TASK_DIM_F_VW.CURR_IND AS glm_task_dim_f_vw_curr_ind,
    CASE
        WHEN GLM_TASK_DIM_F_VW.CURR_MLSTN_IND = 1 THEN GLM_TASK_DIM_F_VW.GLM_MLSTN_DESC
    END as milestone,
    GLM_TASK_DIM_F_VW.TASK_SK_ID AS task_sk_id,
    GLM_TASK_DIM_F_VW.MLSTN_CMPLT_IND AS mlstn_cmplt_ind,
    GLM_TASK_DIM_F_VW.GLM_TASK_ID AS glm_task_id,
    GLM_TASK_DIM_F_VW.TASK_PRE_REQ_DUE_TIME_RANGE AS time_range,
    GLM_TASK_DIM_F_VW.TASK_PRE_REQ_RSN_DESC as what_is_needed,
    GLM_TASK_DIM_F_VW.TASK_PRE_REQ_AREA_DESC as who_is_responsible,
    '' AS submission_due_date
FROM
    `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_lp_metrics_vw_v2 LP_METRICS
    LEFT OUTER JOIN (
        SELECT
            *
        FROM
            `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_task_dim_f_vw_v2
        WHERE
            GLM_TASK_STATUS_CD = 3 AND MLSTN_CMPLT_IND != 1 -- Including only the tasks which are PENDING
    ) GLM_TASK_DIM_F_VW ON LP_METRICS.LIC_SK_ID = GLM_TASK_DIM_F_VW.LIC_SK_ID
    AND LP_METRICS.LANG_CD = GLM_TASK_DIM_F_VW.LANG_CD
    AND LP_METRICS.CNTRY_CD = GLM_TASK_DIM_F_VW.CNTRY_CD
WHERE
    LP_METRICS.GLM_LICENSE_STATUS_CD IN (2, 6, 7);

CREATE
OR REPLACE TABLE `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.glm_alert_agg AS
SELECT
    *
FROM
    `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.glm_alert_agg_vw;

-- REPORTING - Last Updated Note and Complete & Expired
CREATE
OR REPLACE VIEW `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_last_update_note_vw AS
SELECT
    LP_METRICS.LIC_SK_ID AS lic_sk_id,
    LP_METRICS.GLM_LIC_APPLN_ID AS glm_lic_appln_id,
    LP_METRICS.ASSGN_GLM_USERID AS assgn_glm_userid,
    LP_METRICS.STORE_NBR AS store_nbr,
    LP_METRICS.CITY AS city,
    LP_METRICS.MARKET AS market,
    LP_METRICS.STATE AS state,
    LP_METRICS.GLM_APPLN_TYPE_DESC AS glm_appln_type_desc,
    LP_METRICS.GLM_LIC_CLASS_DESC AS glm_lic_class_desc,
    LP_METRICS.GLM_LIC_CATG_DESC AS glm_lic_catg_desc,
    LP_METRICS.LIC_TYPE_DESC AS lic_type_desc,
    LP_METRICS.GOVT_AGNCY_TYPE_DESC AS govt_agncy_type_desc,
    LP_METRICS.EXP_DT AS exp_dt,
    LP_METRICS.EFFECTIVE_TS AS effective_ts,
    LP_METRICS.GLM_LIC_STATUS_DESC AS glm_lic_status_desc,
    LP_METRICS.CURR_GLM_MLSTN_DESC AS glm_mlstn_desc,
    LP_METRICS.COMPLETED_BY_USERID AS completed_by_userid,
    LP_METRICS.COMPLETE_DATE AS complete_date,
    LP_METRICS.GLM_ACTV_CLASS_DESC AS glm_actv_class_desc,
    LP_METRICS.LIC_ACTV_DESC AS lic_actv_desc,
    LP_METRICS.START_DATE AS start_date,
    LP_METRICS.BANNER_DESCRIPTION as facility_type,
    LP_METRICS.OPEN_STATUS_DESC as facility_status,
    LP_METRICS.LANG_CD AS lang_cd,
    LP_METRICS.LANG_DESC AS lang_desc,
    LP_METRICS.BUSCON_IMPACTED AS buscon_impacted,
    LP_METRICS.BUSCON_IMP_RSN_DESC AS high_risk_document_ind,
    LP_METRICS.BUSCON_END_DATE_PVD as agency_exception_extension_end_date_provided,
    LP_METRICS.BUSCON_END_DATE as agency_exception_extension_end_date,
    IF(
        GLM_ACTV_CLASS_DESC != 'Single',
        CAST(LP_METRICS.ACTIVITY_COUNT AS STRING),
        ''
    ) AS total_activity_count,
    CASE
        WHEN LP_METRICS.GLM_MLSTN_CD_5_COMPLETE_IND = 1 THEN 'Submitted'
        WHEN LP_METRICS.CURR_GLM_MILESTONE_CD = 2 THEN 'Submitted'
        ELSE 'Not Submitted'
    END AS submission_status,
    CASE
        WHEN MULT_DOC_IND = 0 THEN 'Master'
        WHEN MULT_DOC_IND = 1 THEN 'Multiple'
    END AS activity_class_type,
    CASE
        WHEN LP_METRICS.PENDING_LICENSE_ALERT_IND = 1 THEN 'Alerts'
        WHEN LP_METRICS.PENDING_LICENSE_ALERT_IND = 0 THEN 'No Alerts'
    END AS alert_status,
    GLM_PROJECT_LICENSE.PROJ_ID AS project_id,
    COALESCE(GLM_PROJECT_LICENSE.PROJ_TYPE_DESC, '') AS project_type,
    COALESCE(GLM_LICENSE_NOTE.GLM_TASK_NOTE_TXT, '') as last_updated_note,
    COALESCE(GLM_CONTACT_F_VW.GLM_CNTCT_LINE3, '') AS agency_name,
    COALESCE(GLM_TASK_DIM_F_VW.TASK_PRE_REQ_RSN_DESC, '') AS what_is_needed,
    GLM_TASK_DIM_F_VW.TASK_PRE_REQ_DUE_TS AS due_date_for_what_is_needed,
    COALESCE(GLM_TASK_DIM_F_VW.TASK_PRE_REQ_AREA_DESC, '') AS who_is_responsible
FROM
    `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_lp_metrics_vw_v2 LP_METRICS
    LEFT OUTER JOIN `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_task_dim_f_vw_v2 GLM_TASK_DIM_F_VW ON LP_METRICS.LIC_SK_ID = GLM_TASK_DIM_F_VW.LIC_SK_ID
    AND LP_METRICS.CNTRY_CD = GLM_TASK_DIM_F_VW.CNTRY_CD
    AND LP_METRICS.LANG_CD = GLM_TASK_DIM_F_VW.LANG_CD
    AND LP_METRICS.CURR_GLM_MILESTONE_CD = GLM_TASK_DIM_F_VW.GLM_MLSTN_CD
    LEFT OUTER JOIN (
        SELECT
            GLM_LIC_APPLN_ID,
            CNTRY_CD,
            LANG_CD,
            GLM_CNTCT_LINE3
        FROM
            `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_contact_f_vw_v1
        WHERE
            GLM_CNTCT_TYPE_CD = 1 -- This corresponds to Agency Notes, which provides us with Agency Name
    ) GLM_CONTACT_F_VW ON LP_METRICS.GLM_LIC_APPLN_ID = GLM_CONTACT_F_VW.GLM_LIC_APPLN_ID
    AND LP_METRICS.CNTRY_CD = GLM_CONTACT_F_VW.CNTRY_CD
    AND LP_METRICS.LANG_CD = GLM_CONTACT_F_VW.LANG_CD
    LEFT OUTER JOIN `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_project_license_vw_v1 GLM_PROJECT_LICENSE ON LP_METRICS.LIC_SK_ID = GLM_PROJECT_LICENSE.LIC_SK_ID
    AND LP_METRICS.CNTRY_CD = GLM_PROJECT_LICENSE.CNTRY_CD
    AND LP_METRICS.LANG_CD = GLM_PROJECT_LICENSE.LANG_CD
    LEFT OUTER JOIN `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_license_note_vw_v1 GLM_LICENSE_NOTE ON LP_METRICS.LIC_SK_ID = GLM_LICENSE_NOTE.LIC_SK_ID
    AND LP_METRICS.CNTRY_CD = GLM_LICENSE_NOTE.CNTRY_CD
    AND GLM_TASK_DIM_F_VW.TASK_SK_ID = GLM_LICENSE_NOTE.TASK_SK_ID;

CREATE
OR REPLACE TABLE `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_last_update_note AS
SELECT
    *
FROM
    `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_last_update_note_vw;

-- REPORTING - Payment Report
CREATE
OR REPLACE VIEW `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_payment_report_vw AS
SELECT
    LP_METRICS.GLM_LIC_APPLN_ID AS glm_lic_appln_id,
    LP_METRICS.CNTRY_CD AS cntry_cd,
    LP_METRICS.LANG_CD AS lang_cd,
    LP_METRICS.MARKET AS market,
    LP_METRICS.GLM_APPLN_TYPE_CD AS glm_appln_type_cd,
    LP_METRICS.GLM_LIC_CLASS_CD AS glm_lic_class_cd,
    LP_METRICS.GLM_LIC_CATG_CD AS glm_lic_catg_cd,
    LP_METRICS.LIC_TYPE_CD AS lic_type_cd,
    LP_METRICS.LIC_TYPE_DESC AS lic_type_desc,
    LP_METRICS.GLM_LIC_CATG_DESC AS glm_lic_catg_desc,
    LP_METRICS.GLM_APPLN_TYPE_DESC AS glm_appln_type_desc,
    LP_METRICS.GLM_LIC_CLASS_DESC AS glm_lic_class_desc,
    LP_METRICS.LANG_DESC AS language_desc,
    LP_METRICS.STORE_NBR as facility_nbr,
    LP_METRICS.GOVT_AGNCY_TYPE_DESC AS govt_agncy_type_desc,
    GLM_TASK_DIM_F_VW.TASK_SK_ID AS task_sk_id,
    GLM_TASK_DIM_F_VW.GLM_TASK_ID AS glm_task_id,
    GLM_PAYMENT_D_VW.PYMT_NBR AS payment_id,
    GLM_PAYMENT_D_VW.SAP_INV_NBR AS invoice_nbr,
    GLM_PAYMENT_D_VW.GLM_PYMT_STATUS_DESC AS payment_status,
    GLM_PAYMENT_D_VW.PYMT_CREATE_TS AS payment_request_date,
    GLM_PAYMENT_D_VW.PYMT_RCV_TS AS payment_issued_date,
    -- ???
    GLM_PAYMENT_D_VW.GEN_LDGR_ACCT_NBR AS gl_acc_nbr,
    GLM_PAYMENT_D_VW.TOT_PYMT_AMT AS payment_amnt,
    GLM_PAYMENT_D_VW.GLM_PYMT_MTHD_DESC AS payment_method,
    GLM_PAYMENT_D_VW.GLM_PYMT_TYPE_DESC AS payment_type,
    GLM_PAYMENT_D_VW.VEND_NBR AS vend_nbr,
    GLM_PAYMENT_D_VW.VEND_NM AS vend_nm,
    -- glm_contact_line3, contact_type_cd = 1
    GLM_PAYMENT_D_VW.RQSTR_USER_ID AS requested_by,
    GLM_PAYMENT_D_VW.GLM_APPVR_USER_ID AS approved_by,
    '' AS vendor_type,
    '' AS vendor_postal_cd,
    GLM_PAYMENT_D_VW.CHK_NBR AS chk_nbr,
    GLM_PAYMENT_D_VW.MNY_ORDER_NBR AS mny_order_nbr
FROM
    `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_lp_metrics_vw_v2 LP_METRICS
    JOIN `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_task_dim_f_vw_v2 GLM_TASK_DIM_F_VW ON LP_METRICS.LIC_SK_ID = GLM_TASK_DIM_F_VW.LIC_SK_ID
    AND LP_METRICS.LANG_CD = GLM_TASK_DIM_F_VW.LANG_CD
    AND LP_METRICS.CNTRY_CD = GLM_TASK_DIM_F_VW.CNTRY_CD
    JOIN `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.poc_glm_payment_d_vw_v1 GLM_PAYMENT_D_VW ON GLM_TASK_DIM_F_VW.GLM_TASK_ID = GLM_PAYMENT_D_VW.GLM_TASK_ID
    AND GLM_TASK_DIM_F_VW.CNTRY_CD = GLM_PAYMENT_D_VW.CNTRY_CD
    AND GLM_TASK_DIM_F_VW.LANG_CD = GLM_PAYMENT_D_VW.LANG_CD
    AND LP_METRICS.STORE_NBR = GLM_PAYMENT_D_VW.FCLTY_NBR
WHERE
    LP_METRICS.CNTRY_CD IN ('CA', 'MX') -- MX
    AND LP_METRICS.LANG_CD IN ('101', '102', '103')
    AND LP_METRICS.GLM_APPLN_TYPE_DESC IN (
        'LICENSE',
        'IN SCOPE SUPPORTING DOCUMENT',
        'LICENCIA',
        'DOCUMENTO SOPORTE IN SCOPE',
        'LICENSE'
    ) -- Add wordings in Spanish
    AND GLM_PAYMENT_D_VW.GLM_PYMT_MTHD_DESC IN (
        'ADVANCE CHEQUE',
        'CHEQUE ANTICIPO',
        'URGENT/EXPRESS CHECK',
        'CHEQUE EXPRESS/URGENTE',
        'CREDIT CARD',
        'TARJETA DE CRÉDITO',
        'WIRE TRANSFER',
        'TRANSFERENCIA BANCARIA',
        'CHEQUE SAP'
    );

CREATE
OR REPLACE TABLE `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_payment_report AS
SELECT
    *
FROM
    `wmt-ww-gg-gec-prod`.ww_gg_gec_glm_dl_secure.gg_glm_payment_report_vw;

-- REPORTING - Federal Firearm Report
-- License Type Code = FIREARMS FEDERAL(LICENSE_TYPE_CD = 30001)
-- License Status = Completed, Archived and Expired (GLM_LICENSE_STATUS_DESC)
-- Document Type = License/Permit (LICENSE_DOC_TYPE_CD = 24)
-- License Application Type = License (GLM_APPLICATION_TYPE_CD = 2)
-- License Class = Facility (GLM_LICENSE_CLASS_CD = 2)
-- Facility Number
-- FFL number
-- Expiration Date
-- Effective Date
-- Facility Name
-- Address
-- City
-- State
-- Postal Code
-- REPORTING - Payment Search
-- Required for Mexico
-- Language code: Spanish
-- Application Type: License, In Scope Supporting Document
-- Payment Request Date From: January 1
-- Payment Request Date To: Current Date
-- Payment Method: Advance Check, Urgent/Express Check, Credit Card, Wire Transfer
-- Required for Canada
-- Language code: English
-- Application Type: License
-- Payment Status: Completed
-- Payment Request Date From: 2 weeks before Current Date
-- Payment Request Date To: Current Date
-- Payment Method: Cheque SAP

--gsutil rm gs://1c1deebf2e27db399b533fe3f05227507a88a91428ac615ed1b24d164b5209/code/gg-gec-glm-etl/latest/ddl/bq-reporting.sql
--gsutil cp ddl/bq-reporting.sql gs://1c1deebf2e27db399b533fe3f05227507a88a91428ac615ed1b24d164b5209/code/gg-gec-glm-etl/latest/ddl/