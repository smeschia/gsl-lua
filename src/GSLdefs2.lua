-- Constants

gsl.support.gsl_get_interp_type:types{ret = "pointer", "int"}
gsl.support.gsl_debug:types{ret = "void", "pointer", "int"}

gsl.__register('gsl_set_error_handler', {ret = 'pointer', 'callback'})

-- VECTORS
--	gsl_vector * gsl_vector_alloc (uint n)
gsl.__register('gsl_vector_alloc', {ret = 'pointer', 'uint'})	

--	gsl_vector * gsl_vector_calloc (uint n)
gsl.__register('gsl_vector_calloc', {ret = 'pointer', 'uint'})	

--	void gsl_vector_free (gsl_vector * v)
gsl.__register('gsl_vector_free', {ret = 'void', 'pointer'})	

--	double gsl_vector_get (const gsl_vector * v, uint i)
gsl.__register('gsl_vector_get', {ret = 'double', 'pointer', 'uint'})	

--	void gsl_vector_set (gsl_vector * v, uint i, double x)
gsl.__register('gsl_vector_set', {ret = 'void', 'pointer', 'uint', 'double'})	

--	double * gsl_vector_ptr (gsl_vector * v, uint i)
gsl.__register('gsl_vector_ptr', {ret = 'pointer', 'pointer', 'uint'})	

--	const double * gsl_vector_const_ptr (const gsl_vector * v, uint i)
gsl.__register('gsl_vector_const_ptr', {ret = 'pointer', 'pointer', 'uint'})	

--	int gsl_vector_add (gsl_vector * a, const gsl_vector * b)
gsl.__register('gsl_vector_add', {ret = 'int', 'pointer', 'pointer'})	

--	int gsl_vector_sub (gsl_vector * a, const gsl_vector * b)
gsl.__register('gsl_vector_sub', {ret = 'int', 'pointer', 'pointer'})	

--	int gsl_vector_mul (gsl_vector * a, const gsl_vector * b)
gsl.__register('gsl_vector_mul', {ret = 'int', 'pointer', 'pointer'})	

--	int gsl_vector_div (gsl_vector * a, const gsl_vector * b)
gsl.__register('gsl_vector_div', {ret = 'int', 'pointer', 'pointer'})	

--	int gsl_vector_scale (gsl_vector * a, const double x)
gsl.__register('gsl_vector_scale', {ret = 'int', 'pointer', 'double'})	

--	int gsl_vector_add_constant (gsl_vector * a, const double x)
gsl.__register('gsl_vector_add_constant', {ret = 'int', 'pointer', 'double'})	

--	double gsl_vector_max (const gsl_vector * v)
gsl.__register('gsl_vector_max', {ret = 'double', 'pointer'})	

--	double gsl_vector_min (const gsl_vector * v)
gsl.__register('gsl_vector_min', {ret = 'double', 'pointer'})	

--	void gsl_vector_minmax (const gsl_vector * v, double * min_out, double * max_out)
gsl.__register('gsl_vector_minmax', {ret = 'void', 'pointer', 'ref double', 'ref double'})	

--	uint gsl_vector_max_index (const gsl_vector * v)
gsl.__register('gsl_vector_max_index', {ret = 'uint', 'pointer'})	

--	uint gsl_vector_min_index (const gsl_vector * v)
gsl.__register('gsl_vector_min_index', {ret = 'uint', 'pointer'})	

--	void gsl_vector_minmax_index (const gsl_vector * v, uint * imin, uint * imax)
gsl.__register('gsl_vector_minmax_index', {ret = 'void', 'pointer', 'ref uint', 'ref uint'})	

--	int gsl_vector_memcpy (gsl_vector * dest, const gsl_vector * src)
gsl.__register('gsl_vector_memcpy', {ret = 'int', 'pointer', 'pointer'})	

--	int gsl_vector_swap (gsl_vector * v, gsl_vector * w)
gsl.__register('gsl_vector_swap', {ret = 'int', 'pointer', 'pointer'})	


-- MATRICES
--	gsl_matrix * gsl_matrix_alloc (uint n1, uint n2)
gsl.__register('gsl_matrix_alloc', {ret = 'pointer', 'uint', 'uint'})	

--	gsl_matrix * gsl_matrix_calloc (uint n1, uint n2)
gsl.__register('gsl_matrix_calloc', {ret = 'pointer', 'uint', 'uint'})	

--	void gsl_matrix_free (gsl_matrix * m)
gsl.__register('gsl_matrix_free', {ret = 'void', 'pointer'})	

--	double gsl_matrix_get (const gsl_matrix * m, uint i, uint j)
gsl.__register('gsl_matrix_get', {ret = 'double', 'pointer', 'uint', 'uint'})	

--	void gsl_matrix_set (gsl_matrix * m, uint i, uint j, double x)
gsl.__register('gsl_matrix_set', {ret = 'void', 'pointer', 'uint', 'uint', 'double'})	

--	double * gsl_matrix_ptr (gsl_matrix * m, uint i, uint j)
gsl.__register('gsl_matrix_ptr', {ret = 'pointer', 'pointer', 'uint', 'uint'})	

--	const double * gsl_matrix_const_ptr (const gsl_matrix * m, uint i, uint j)
gsl.__register('gsl_matrix_const_ptr', {ret = 'pointer', 'pointer', 'uint', 'uint'})	

--	int gsl_matrix_get_row (gsl_vector * v, const gsl_matrix * m, uint i)
gsl.__register('gsl_matrix_get_row', {ret = 'int', 'pointer', 'pointer', 'uint'})	

--	int gsl_matrix_get_col (gsl_vector * v, const gsl_matrix * m, uint j)
gsl.__register('gsl_matrix_get_col', {ret = 'int', 'pointer', 'pointer', 'uint'})	

--	int gsl_matrix_set_row (gsl_matrix * m, uint i, const gsl_vector * v)
gsl.__register('gsl_matrix_set_row', {ret = 'int', 'pointer', 'uint', 'pointer'})	

--	int gsl_matrix_set_col (gsl_matrix * m, uint j, const gsl_vector * v)
gsl.__register('gsl_matrix_set_col', {ret = 'int', 'pointer', 'uint', 'pointer'})	

--	int gsl_matrix_swap_rows (gsl_matrix * m, uint i, uint j)
gsl.__register('gsl_matrix_swap_rows', {ret = 'int', 'pointer', 'uint', 'uint'})	

--	int gsl_matrix_swap_columns (gsl_matrix * m, uint i, uint j)
gsl.__register('gsl_matrix_swap_columns', {ret = 'int', 'pointer', 'uint', 'uint'})	

--	int gsl_matrix_swap_rowcol (gsl_matrix * m, uint i, uint j)
gsl.__register('gsl_matrix_swap_rowcol', {ret = 'int', 'pointer', 'uint', 'uint'})	

--	int gsl_matrix_transpose_memcpy (gsl_matrix * dest, const gsl_matrix * src)
gsl.__register('gsl_matrix_transpose_memcpy', {ret = 'int', 'pointer', 'pointer'})	

--	int gsl_matrix_transpose (gsl_matrix * m)
gsl.__register('gsl_matrix_transpose', {ret = 'int', 'pointer'})	

--	int gsl_matrix_add (gsl_matrix * a, const gsl_matrix * b)
gsl.__register('gsl_matrix_add', {ret = 'int', 'pointer', 'pointer'})	

--	int gsl_matrix_sub (gsl_matrix * a, const gsl_matrix * b)
gsl.__register('gsl_matrix_sub', {ret = 'int', 'pointer', 'pointer'})	

--	int gsl_matrix_mul_elements (gsl_matrix * a, const gsl_matrix * b)
gsl.__register('gsl_matrix_mul_elements', {ret = 'int', 'pointer', 'pointer'})	

--	int gsl_matrix_div_elements (gsl_matrix * a, const gsl_matrix * b)
gsl.__register('gsl_matrix_div_elements', {ret = 'int', 'pointer', 'pointer'})	

--	int gsl_matrix_scale (gsl_matrix * a, const double x)
gsl.__register('gsl_matrix_scale', {ret = 'int', 'pointer', 'double'})	

--	int gsl_matrix_add_constant (gsl_matrix * a, const double x)
gsl.__register('gsl_matrix_add_constant', {ret = 'int', 'pointer', 'double'})	

--	double gsl_matrix_max (const gsl_matrix * m)
gsl.__register('gsl_matrix_max', {ret = 'double', 'pointer'})	

--	double gsl_matrix_min (const gsl_matrix * m)
gsl.__register('gsl_matrix_min', {ret = 'double', 'pointer'})	

--	void gsl_matrix_minmax (const gsl_matrix * m, double * min_out, double * max_out)
gsl.__register('gsl_matrix_minmax', {ret = 'void', 'pointer', 'ref double', 'ref double'})	

--	void gsl_matrix_max_index (const gsl_matrix * m, uint * imax, uint * jmax)
gsl.__register('gsl_matrix_max_index', {ret = 'void', 'pointer', 'ref uint', 'ref uint'})	

--	void gsl_matrix_min_index (const gsl_matrix * m, uint * imin, uint * jmin)
gsl.__register('gsl_matrix_min_index', {ret = 'void', 'pointer', 'ref uint', 'ref uint'})	

--	void gsl_matrix_minmax_index (const gsl_matrix * m, uint * imin, uint * jmin, uint * imax, uint * jmax)
gsl.__register('gsl_matrix_minmax_index', {ret = 'void', 'pointer', 'ref uint', 'ref uint', 'ref uint', 'ref uint'})	

--	int gsl_matrix_isnull (const gsl_matrix * m)
gsl.__register('gsl_matrix_isnull', {ret = 'int', 'pointer'})	

--	int gsl_matrix_ispos (const gsl_matrix * m)
gsl.__register('gsl_matrix_ispos', {ret = 'int', 'pointer'})	

--	int gsl_matrix_isneg (const gsl_matrix * m)
gsl.__register('gsl_matrix_isneg', {ret = 'int', 'pointer'})	

--	int gsl_matrix_isnonneg (const gsl_matrix * m)
gsl.__register('gsl_matrix_isnonneg', {ret = 'int', 'pointer'})	

-- LINEAR ALGEBRA
--	int gsl_linalg_LU_decomp (gsl_matrix * A, gsl_permutation * p, int * signum)
gsl.__register('gsl_linalg_LU_decomp', {ret = 'int', 'pointer', 'pointer', 'ref int'})	

--	int gsl_linalg_LU_solve (const gsl_matrix * LU, const gsl_permutation * p, const gsl_vector * b, gsl_vector * x)
gsl.__register('gsl_linalg_LU_solve', {ret = 'int', 'pointer', 'pointer', 'pointer', 'pointer'})	

--	int gsl_linalg_LU_svx (const gsl_matrix * LU, const gsl_permutation * p, gsl_vector * x)
gsl.__register('gsl_linalg_LU_svx', {ret = 'int', 'pointer', 'pointer', 'pointer'})	

--	int gsl_linalg_LU_refine (const gsl_matrix * A, const gsl_matrix * LU, const gsl_permutation * p, const gsl_vector * b, gsl_vector * x, gsl_vector * residual)
gsl.__register('gsl_linalg_LU_refine', {ret = 'int', 'pointer', 'pointer', 'pointer', 'pointer', 'pointer', 'pointer'})	

--	int gsl_linalg_LU_invert (const gsl_matrix * LU, const gsl_permutation * p, gsl_matrix * inverse)
gsl.__register('gsl_linalg_LU_invert', {ret = 'int', 'pointer', 'pointer', 'pointer'})	

--	double gsl_linalg_LU_det (gsl_matrix * LU, int signum)
gsl.__register('gsl_linalg_LU_det', {ret = 'double', 'pointer', 'int'})	

--	double gsl_linalg_LU_lndet (gsl_matrix * LU)
gsl.__register('gsl_linalg_LU_lndet', {ret = 'double', 'pointer'})	

--	int gsl_linalg_LU_sgndet (gsl_matrix * LU, int signum)
gsl.__register('gsl_linalg_LU_sgndet', {ret = 'int', 'pointer', 'int'})	

-- NUMERICAL INTEGRATION
--	int gsl_integration_qng (const gsl_function * f, double a, double b, double epsabs, double epsrel, double * result, double * abserr, size_t * neval)
gsl.__register('gsl_integration_qng', {ret = 'int', 'pointer', 'double', 'double', 'double', 'double', 'ref double', 'ref double', 'ref uint'})	

--	gsl_integration_workspace * gsl_integration_workspace_alloc (size_t n)
gsl.__register('gsl_integration_workspace_alloc', {ret = 'pointer', 'uint'})	

--	void gsl_integration_workspace_free (gsl_integration_workspace * w)
gsl.__register('gsl_integration_workspace_free', {ret = 'void', 'pointer'})	

--	int gsl_integration_qag (const gsl_function * f, double a, double b, double epsabs, double epsrel, size_t limit, int key, gsl_integration_workspace * workspace, double * result, double * abserr)
gsl.__register('gsl_integration_qag', {ret = 'int', 'pointer', 'double', 'double', 'double', 'double', 'uint', 'int', 'pointer', 'ref double', 'ref double'})	

--	int gsl_integration_qags (const gsl_function * f, double a, double b, double epsabs, double epsrel, size_t limit, gsl_integration_workspace * workspace, double * result, double * abserr)
gsl.__register('gsl_integration_qags', {ret = 'int', 'pointer', 'double', 'double', 'double', 'double', 'uint', 'pointer', 'ref double', 'ref double'})	

--	int gsl_integration_qagp (const gsl_function * f, double * pts, size_t npts, double epsabs, double epsrel, size_t limit, gsl_integration_workspace * workspace, double * result, double * abserr)
gsl.__register('gsl_integration_qagp', {ret = 'int', 'pointer', 'ref double', 'uint', 'double', 'double', 'uint', 'pointer', 'ref double', 'ref double'})	

--	int gsl_integration_qagi (gsl_function * f, double epsabs, double epsrel, size_t limit, gsl_integration_workspace * workspace, double * result, double * abserr)
gsl.__register('gsl_integration_qagi', {ret = 'int', 'pointer', 'double', 'double', 'uint', 'pointer', 'ref double', 'ref double'})	

--	int gsl_integration_qagiu (gsl_function * f, double a, double epsabs, double epsrel, size_t limit, gsl_integration_workspace * workspace, double * result, double * abserr)
gsl.__register('gsl_integration_qagiu', {ret = 'int', 'pointer', 'double', 'double', 'double', 'uint', 'pointer', 'ref double', 'ref double'})	

--	int gsl_integration_qagil (gsl_function * f, double b, double epsabs, double epsrel, size_t limit, gsl_integration_workspace * workspace, double * result, double * abserr)
gsl.__register('gsl_integration_qagil', {ret = 'int', 'pointer', 'double', 'double', 'double', 'uint', 'pointer', 'ref double', 'ref double'})	

--	gsl_integration_qaws_table * gsl_integration_qaws_table_alloc (double alpha, double beta, int mu, int nu)
gsl.__register('gsl_integration_qaws_table_alloc', {ret = 'pointer', 'double', 'double', 'int', 'int'})	

--	int gsl_integration_qaws_table_set (gsl_integration_qaws_table * t, double alpha, double beta, int mu, int nu)
gsl.__register('gsl_integration_qaws_table_set', {ret = 'int', 'pointer', 'double', 'double', 'int', 'int'})	

--	void gsl_integration_qaws_table_free (gsl_integration_qaws_table * t)
gsl.__register('gsl_integration_qaws_table_free', {ret = 'void', 'pointer'})	

--	int gsl_integration_qaws (gsl_function * f, const double a, const double b, gsl_integration_qaws_table * t, const double epsabs, const double epsrel, const size_t limit, gsl_integration_workspace * workspace, double * result, double * abserr)
gsl.__register('gsl_integration_qaws', {ret = 'int', 'pointer', 'double', 'double', 'pointer', 'double', 'double', 'uint', 'pointer', 'ref double', 'ref double'})	

-- EIGENSYSTEMS
--	gsl_eigen_symm_workspace * gsl_eigen_symm_alloc (const size_t n)
gsl.__register('gsl_eigen_symm_alloc', {ret = 'pointer', 'uint'})	

--	void gsl_eigen_symm_free (gsl_eigen_symm_workspace * w)
gsl.__register('gsl_eigen_symm_free', {ret = 'void', 'pointer'})	

--	int gsl_eigen_symm (gsl_matrix * A, gsl_vector * eval, gsl_eigen_symm_workspace * w)
gsl.__register('gsl_eigen_symm', {ret = 'int', 'pointer', 'pointer', 'pointer'})	

--	gsl_eigen_symmv_workspace * gsl_eigen_symmv_alloc (const size_t n)
gsl.__register('gsl_eigen_symmv_alloc', {ret = 'pointer', 'uint'})	

--	void gsl_eigen_symmv_free (gsl_eigen_symmv_workspace * w)
gsl.__register('gsl_eigen_symmv_free', {ret = 'void', 'pointer'})	

--	int gsl_eigen_symmv (gsl_matrix * A, gsl_vector * eval, gsl_matrix * evec, gsl_eigen_symmv_workspace * w)
gsl.__register('gsl_eigen_symmv', {ret = 'int', 'pointer', 'pointer', 'pointer', 'pointer'})	

--	gsl_eigen_nonsymm_workspace * gsl_eigen_nonsymm_alloc (const size_t n)
gsl.__register('gsl_eigen_nonsymm_alloc', {ret = 'pointer', 'uint'})	

--	void gsl_eigen_nonsymm_free (gsl_eigen_nonsymm_workspace * w)
gsl.__register('gsl_eigen_nonsymm_free', {ret = 'void', 'pointer'})	

--	void gsl_eigen_nonsymm_params (const int compute_t, const int balance, gsl_eigen_nonsymm_workspace * w)
gsl.__register('gsl_eigen_nonsymm_params', {ret = 'void', 'int', 'int', 'pointer'})	

--	int gsl_eigen_nonsymm (gsl_matrix * A, gsl_vector_complex * eval, gsl_eigen_nonsymm_workspace * w)
gsl.__register('gsl_eigen_nonsymm', {ret = 'int', 'pointer', 'pointer', 'pointer'})	

--	int gsl_eigen_nonsymm_Z (gsl_matrix * A, gsl_vector_complex * eval, gsl_matrix * Z, gsl_eigen_nonsymm_workspace * w)
gsl.__register('gsl_eigen_nonsymm_Z', {ret = 'int', 'pointer', 'pointer', 'pointer', 'pointer'})	

--	gsl_eigen_nonsymmv_workspace * gsl_eigen_nonsymmv_alloc (const size_t n)
gsl.__register('gsl_eigen_nonsymmv_alloc', {ret = 'pointer', 'uint'})	

--	void gsl_eigen_nonsymmv_free (gsl_eigen_nonsymmv_workspace * w)
gsl.__register('gsl_eigen_nonsymmv_free', {ret = 'void', 'pointer'})	

--	void gsl_eigen_nonsymmv_params (const int balance, gsl_eigen_nonsymm_workspace * w)
-- gsl.__register('gsl_eigen_nonsymmv_params', {ret = 'void', 'int', 'pointer'})	

--	int gsl_eigen_nonsymmv (gsl_matrix * A, gsl_vector_complex * eval, gsl_matrix_complex * evec, gsl_eigen_nonsymmv_workspace * w)
gsl.__register('gsl_eigen_nonsymmv', {ret = 'int', 'pointer', 'pointer', 'pointer', 'pointer'})	

--	int gsl_eigen_nonsymmv_Z (gsl_matrix * A, gsl_vector_complex * eval, gsl_matrix_complex * evec, gsl_matrix * Z, gsl_eigen_nonsymmv_workspace * w)
gsl.__register('gsl_eigen_nonsymmv_Z', {ret = 'int', 'pointer', 'pointer', 'pointer', 'pointer', 'pointer'})	

-- PERMUTATIONS
--	gsl_permutation * gsl_permutation_alloc (size_t n)
gsl.__register('gsl_permutation_alloc', {ret = 'pointer', 'uint'})	

--	gsl_permutation * gsl_permutation_calloc (size_t n)
gsl.__register('gsl_permutation_calloc', {ret = 'pointer', 'uint'})	

--	void gsl_permutation_init (gsl_permutation * p)
gsl.__register('gsl_permutation_init', {ret = 'void', 'pointer'})	

--	void gsl_permutation_free (gsl_permutation * p)
gsl.__register('gsl_permutation_free', {ret = 'void', 'pointer'})	

--	int gsl_permutation_memcpy (gsl_permutation * dest, const gsl_permutation * src)
gsl.__register('gsl_permutation_memcpy', {ret = 'int', 'pointer', 'pointer'})	

--	size_t gsl_permutation_get (const gsl_permutation * p, const size_t i)
gsl.__register('gsl_permutation_get', {ret = 'uint', 'pointer', 'uint'})	

--	int gsl_permutation_swap (gsl_permutation * p, const size_t i, const size_t j)
gsl.__register('gsl_permutation_swap', {ret = 'int', 'pointer', 'uint', 'uint'})	

--	void gsl_permutation_reverse (gsl_permutation * p)
gsl.__register('gsl_permutation_reverse', {ret = 'void', 'pointer'})	

--	int gsl_permutation_inverse (gsl_permutation * inv, const gsl_permutation * p)
gsl.__register('gsl_permutation_inverse', {ret = 'int', 'pointer', 'pointer'})	

--	int gsl_permutation_next (gsl_permutation * p)
gsl.__register('gsl_permutation_next', {ret = 'int', 'pointer'})	

--	int gsl_permutation_prev (gsl_permutation * p)
gsl.__register('gsl_permutation_prev', {ret = 'int', 'pointer'})	

--	int gsl_matrix_memcpy (gsl_matrix * dest, const gsl_matrix * src)
gsl.__register('gsl_matrix_memcpy', {ret = 'int', 'pointer', 'pointer'})	

--	int gsl_matrix_swap (gsl_matrix * m1, gsl_matrix * m2)
gsl.__register('gsl_matrix_swap', {ret = 'int', 'pointer', 'pointer'})	

--	int gsl_blas_dsdot (const gsl_vector_float * x, const gsl_vector_float * y, double * result)
gsl.__register('gsl_blas_dsdot', {ret = 'int', 'pointer', 'pointer', 'ref double'})	

--	int gsl_blas_ddot (const gsl_vector * x, const gsl_vector * y, double * result)
gsl.__register('gsl_blas_ddot', {ret = 'int', 'pointer', 'pointer', 'ref double'})	

--	int gsl_blas_cdotu (const gsl_vector_complex_float * x, const gsl_vector_complex_float * y, gsl_complex_float * dotu)
gsl.__register('gsl_blas_cdotu', {ret = 'int', 'pointer', 'pointer', 'pointer'})	

--	int gsl_blas_zdotu (const gsl_vector_complex * x, const gsl_vector_complex * y, gsl_complex * dotu)
gsl.__register('gsl_blas_zdotu', {ret = 'int', 'pointer', 'pointer', 'pointer'})	

--	int gsl_blas_cdotc (const gsl_vector_complex_float * x, const gsl_vector_complex_float * y, gsl_complex_float * dotc)
gsl.__register('gsl_blas_cdotc', {ret = 'int', 'pointer', 'pointer', 'pointer'})	

--	int gsl_blas_zdotc (const gsl_vector_complex * x, const gsl_vector_complex * y, gsl_complex * dotc)
gsl.__register('gsl_blas_zdotc', {ret = 'int', 'pointer', 'pointer', 'pointer'})	

--	float gsl_blas_snrm2 (const gsl_vector_float * x)
gsl.__register('gsl_blas_snrm2', {ret = 'float', 'pointer'})	

--	double gsl_blas_dnrm2 (const gsl_vector * x)
gsl.__register('gsl_blas_dnrm2', {ret = 'double', 'pointer'})	

--	float gsl_blas_scnrm2 (const gsl_vector_complex_float * x)
gsl.__register('gsl_blas_scnrm2', {ret = 'float', 'pointer'})	

--	double gsl_blas_dznrm2 (const gsl_vector_complex * x)
gsl.__register('gsl_blas_dznrm2', {ret = 'double', 'pointer'})	

--	float gsl_blas_sasum (const gsl_vector_float * x)
gsl.__register('gsl_blas_sasum', {ret = 'float', 'pointer'})	

--	double gsl_blas_dasum (const gsl_vector * x)
gsl.__register('gsl_blas_dasum', {ret = 'double', 'pointer'})	

--	float gsl_blas_scasum (const gsl_vector_complex_float * x)
gsl.__register('gsl_blas_scasum', {ret = 'float', 'pointer'})	

--	double gsl_blas_dzasum (const gsl_vector_complex * x)
gsl.__register('gsl_blas_dzasum', {ret = 'double', 'pointer'})	

--	CBLAS_INDEX_t gsl_blas_isamax (const gsl_vector_float * x)
--gsl.__register('gsl_blas_isamax', {ret = 'CBLAS_INDEX_t', 'pointer'})	

--	CBLAS_INDEX_t gsl_blas_idamax (const gsl_vector * x)
--gsl.__register('gsl_blas_idamax', {ret = 'CBLAS_INDEX_t', 'pointer'})	

--	CBLAS_INDEX_t gsl_blas_icamax (const gsl_vector_complex_float * x)
--gsl.__register('gsl_blas_icamax', {ret = 'CBLAS_INDEX_t', 'pointer'})	

--	CBLAS_INDEX_t gsl_blas_izamax (const gsl_vector_complex * x)
--gsl.__register('gsl_blas_izamax', {ret = 'CBLAS_INDEX_t', 'pointer'})	

--	int gsl_blas_sswap (gsl_vector_float * x, gsl_vector_float * y)
gsl.__register('gsl_blas_sswap', {ret = 'int', 'pointer', 'pointer'})	

--	int gsl_blas_dswap (gsl_vector * x, gsl_vector * y)
gsl.__register('gsl_blas_dswap', {ret = 'int', 'pointer', 'pointer'})	

--	int gsl_blas_cswap (gsl_vector_complex_float * x, gsl_vector_complex_float * y)
gsl.__register('gsl_blas_cswap', {ret = 'int', 'pointer', 'pointer'})	

--	int gsl_blas_zswap (gsl_vector_complex * x, gsl_vector_complex * y)
gsl.__register('gsl_blas_zswap', {ret = 'int', 'pointer', 'pointer'})	

--	int gsl_blas_scopy (const gsl_vector_float * x, gsl_vector_float * y)
gsl.__register('gsl_blas_scopy', {ret = 'int', 'pointer', 'pointer'})	

--	int gsl_blas_dcopy (const gsl_vector * x, gsl_vector * y)
gsl.__register('gsl_blas_dcopy', {ret = 'int', 'pointer', 'pointer'})	

--	int gsl_blas_ccopy (const gsl_vector_complex_float * x, gsl_vector_complex_float * y)
gsl.__register('gsl_blas_ccopy', {ret = 'int', 'pointer', 'pointer'})	

--	int gsl_blas_zcopy (const gsl_vector_complex * x, gsl_vector_complex * y)
gsl.__register('gsl_blas_zcopy', {ret = 'int', 'pointer', 'pointer'})	

--	int gsl_blas_saxpy (float alpha, const gsl_vector_float * x, gsl_vector_float * y)
gsl.__register('gsl_blas_saxpy', {ret = 'int', 'float', 'pointer', 'pointer'})	

--	int gsl_blas_daxpy (double alpha, const gsl_vector * x, gsl_vector * y)
gsl.__register('gsl_blas_daxpy', {ret = 'int', 'double', 'pointer', 'pointer'})	

--	int gsl_blas_caxpy (const gsl_complex_float alpha, const gsl_vector_complex_float * x, gsl_vector_complex_float * y)
--gsl.__register('gsl_blas_caxpy', {ret = 'int', 'gsl_complex_float', 'pointer', 'pointer'})	

--	int gsl_blas_zaxpy (const gsl_complex alpha, const gsl_vector_complex * x, gsl_vector_complex * y)
--gsl.__register('gsl_blas_zaxpy', {ret = 'int', 'gsl_complex', 'pointer', 'pointer'})	

--	void gsl_blas_sscal (float alpha, gsl_vector_float * x)
gsl.__register('gsl_blas_sscal', {ret = 'void', 'float', 'pointer'})	

--	void gsl_blas_dscal (double alpha, gsl_vector * x)
gsl.__register('gsl_blas_dscal', {ret = 'void', 'double', 'pointer'})	

--	void gsl_blas_cscal (const gsl_complex_float alpha, gsl_vector_complex_float * x)
--gsl.__register('gsl_blas_cscal', {ret = 'void', 'gsl_complex_float', 'pointer'})	

--	void gsl_blas_zscal (const gsl_complex alpha, gsl_vector_complex * x)
--gsl.__register('gsl_blas_zscal', {ret = 'void', 'gsl_complex', 'pointer'})	

--	void gsl_blas_csscal (float alpha, gsl_vector_complex_float * x)
gsl.__register('gsl_blas_csscal', {ret = 'void', 'float', 'pointer'})	

--	void gsl_blas_zdscal (double alpha, gsl_vector_complex * x)
gsl.__register('gsl_blas_zdscal', {ret = 'void', 'double', 'pointer'})	

--	int gsl_blas_drotg (double a[], double b[], double c[], double s[])
gsl.__register('gsl_blas_drotg', {ret = 'int', 'ref double', 'ref double', 'ref double', 'ref double'})	

--	int gsl_blas_srot (gsl_vector_float * x, gsl_vector_float * y, float c, float s)
gsl.__register('gsl_blas_srot', {ret = 'int', 'pointer', 'pointer', 'float', 'float'})	

--	int gsl_blas_drot (gsl_vector * x, gsl_vector * y, const double c, const double s)
gsl.__register('gsl_blas_drot', {ret = 'int', 'pointer', 'pointer', 'double', 'double'})	

--	int gsl_blas_drotmg (double d1[], double d2[], double b1[], double b2, double P[])
gsl.__register('gsl_blas_drotmg', {ret = 'int', 'ref double', 'ref double', 'ref double', 'double', 'ref double'})	

--	int gsl_blas_drotm (gsl_vector * x, gsl_vector * y, const double P[])
gsl.__register('gsl_blas_drotm', {ret = 'int', 'pointer', 'pointer', 'ref double'})	

--	int gsl_blas_sgemm (CBLAS_TRANSPOSE_t TransA, CBLAS_TRANSPOSE_t TransB, float alpha, const gsl_matrix_float * A, const gsl_matrix_float * B, float beta, gsl_matrix_float * C)
gsl.__register('gsl_blas_sgemm', {ret = 'int', 'int', 'int', 'float', 'pointer', 'pointer', 'float', 'pointer'})	

--	int gsl_blas_dgemm (CBLAS_TRANSPOSE_t TransA, CBLAS_TRANSPOSE_t TransB, double alpha, const gsl_matrix * A, const gsl_matrix * B, double beta, gsl_matrix * C)
gsl.__register('gsl_blas_dgemm', {ret = 'int', 'int', 'int', 'double', 'pointer', 'pointer', 'double', 'pointer'})	

--	int gsl_blas_cgemm (CBLAS_TRANSPOSE_t TransA, CBLAS_TRANSPOSE_t TransB, const gsl_complex_float alpha, const gsl_matrix_complex_float * A, const gsl_matrix_complex_float * B, const gsl_complex_float beta, gsl_matrix_complex_float * C)
gsl.__register('gsl_blas_cgemm', {ret = 'int', 'int', 'int', 'int', 'pointer', 'pointer', 'int', 'pointer'})	

--	int gsl_blas_zgemm (CBLAS_TRANSPOSE_t TransA, CBLAS_TRANSPOSE_t TransB, const gsl_complex alpha, const gsl_matrix_complex * A, const gsl_matrix_complex * B, const gsl_complex beta, gsl_matrix_complex * C)
gsl.__register('gsl_blas_zgemm', {ret = 'int', 'int', 'int', 'int', 'pointer', 'pointer', 'int', 'pointer'})	

--	int gsl_blas_ssymm (CBLAS_SIDE_t Side, CBLAS_UPLO_t Uplo, float alpha, const gsl_matrix_float * A, const gsl_matrix_float * B, float beta, gsl_matrix_float * C)
gsl.__register('gsl_blas_ssymm', {ret = 'int', 'int', 'int', 'float', 'pointer', 'pointer', 'float', 'pointer'})	

--	int gsl_blas_dsymm (CBLAS_SIDE_t Side, CBLAS_UPLO_t Uplo, double alpha, const gsl_matrix * A, const gsl_matrix * B, double beta, gsl_matrix * C)
gsl.__register('gsl_blas_dsymm', {ret = 'int', 'int', 'int', 'double', 'pointer', 'pointer', 'double', 'pointer'})	

--	int gsl_blas_csymm (CBLAS_SIDE_t Side, CBLAS_UPLO_t Uplo, const gsl_complex_float alpha, const gsl_matrix_complex_float * A, const gsl_matrix_complex_float * B, const gsl_complex_float beta, gsl_matrix_complex_float * C)
gsl.__register('gsl_blas_csymm', {ret = 'int', 'int', 'int', 'int', 'pointer', 'pointer', 'int', 'pointer'})	

--	int gsl_blas_zsymm (CBLAS_SIDE_t Side, CBLAS_UPLO_t Uplo, const gsl_complex alpha, const gsl_matrix_complex * A, const gsl_matrix_complex * B, const gsl_complex beta, gsl_matrix_complex * C)
gsl.__register('gsl_blas_zsymm', {ret = 'int', 'int', 'int', 'int', 'pointer', 'pointer', 'int', 'pointer'})	

--	int gsl_blas_chemm (CBLAS_SIDE_t Side, CBLAS_UPLO_t Uplo, const gsl_complex_float alpha, const gsl_matrix_complex_float * A, const gsl_matrix_complex_float * B, const gsl_complex_float beta, gsl_matrix_complex_float * C)
gsl.__register('gsl_blas_chemm', {ret = 'int', 'int', 'int', 'int', 'pointer', 'pointer', 'int', 'pointer'})	

--	int gsl_blas_zhemm (CBLAS_SIDE_t Side, CBLAS_UPLO_t Uplo, const gsl_complex alpha, const gsl_matrix_complex * A, const gsl_matrix_complex * B, const gsl_complex beta, gsl_matrix_complex * C)
gsl.__register('gsl_blas_zhemm', {ret = 'int', 'int', 'int', 'int', 'pointer', 'pointer', 'int', 'pointer'})	

--	int gsl_blas_strmm (CBLAS_SIDE_t Side, CBLAS_UPLO_t Uplo, CBLAS_TRANSPOSE_t TransA, CBLAS_DIAG_t Diag, float alpha, const gsl_matrix_float * A, gsl_matrix_float * B)
gsl.__register('gsl_blas_strmm', {ret = 'int', 'int', 'int', 'int', 'int', 'float', 'pointer', 'pointer'})	

--	int gsl_blas_dtrmm (CBLAS_SIDE_t Side, CBLAS_UPLO_t Uplo, CBLAS_TRANSPOSE_t TransA, CBLAS_DIAG_t Diag, double alpha, const gsl_matrix * A, gsl_matrix * B)
gsl.__register('gsl_blas_dtrmm', {ret = 'int', 'int', 'int', 'int', 'int', 'double', 'pointer', 'pointer'})	

--	int gsl_blas_ctrmm (CBLAS_SIDE_t Side, CBLAS_UPLO_t Uplo, CBLAS_TRANSPOSE_t TransA, CBLAS_DIAG_t Diag, const gsl_complex_float alpha, const gsl_matrix_complex_float * A, gsl_matrix_complex_float * B)
gsl.__register('gsl_blas_ctrmm', {ret = 'int', 'int', 'int', 'int', 'int', 'int', 'pointer', 'pointer'})	

--	int gsl_blas_ztrmm (CBLAS_SIDE_t Side, CBLAS_UPLO_t Uplo, CBLAS_TRANSPOSE_t TransA, CBLAS_DIAG_t Diag, const gsl_complex alpha, const gsl_matrix_complex * A, gsl_matrix_complex * B)
gsl.__register('gsl_blas_ztrmm', {ret = 'int', 'int', 'int', 'int', 'int', 'int', 'pointer', 'pointer'})	

--	int gsl_blas_strsm (CBLAS_SIDE_t Side, CBLAS_UPLO_t Uplo, CBLAS_TRANSPOSE_t TransA, CBLAS_DIAG_t Diag, float alpha, const gsl_matrix_float * A, gsl_matrix_float * B)
gsl.__register('gsl_blas_strsm', {ret = 'int', 'int', 'int', 'int', 'int', 'float', 'pointer', 'pointer'})	

--	int gsl_blas_dtrsm (CBLAS_SIDE_t Side, CBLAS_UPLO_t Uplo, CBLAS_TRANSPOSE_t TransA, CBLAS_DIAG_t Diag, double alpha, const gsl_matrix * A, gsl_matrix * B)
gsl.__register('gsl_blas_dtrsm', {ret = 'int', 'int', 'int', 'int', 'int', 'double', 'pointer', 'pointer'})	

--	int gsl_blas_ctrsm (CBLAS_SIDE_t Side, CBLAS_UPLO_t Uplo, CBLAS_TRANSPOSE_t TransA, CBLAS_DIAG_t Diag, const gsl_complex_float alpha, const gsl_matrix_complex_float * A, gsl_matrix_complex_float * B)
gsl.__register('gsl_blas_ctrsm', {ret = 'int', 'int', 'int', 'int', 'int', 'int', 'pointer', 'pointer'})	

--	int gsl_blas_ztrsm (CBLAS_SIDE_t Side, CBLAS_UPLO_t Uplo, CBLAS_TRANSPOSE_t TransA, CBLAS_DIAG_t Diag, const gsl_complex alpha, const gsl_matrix_complex * A, gsl_matrix_complex * B)
gsl.__register('gsl_blas_ztrsm', {ret = 'int', 'int', 'int', 'int', 'int', 'int', 'pointer', 'pointer'})	

--	int gsl_blas_ssyrk (CBLAS_UPLO_t Uplo, CBLAS_TRANSPOSE_t Trans, float alpha, const gsl_matrix_float * A, float beta, gsl_matrix_float * C)
gsl.__register('gsl_blas_ssyrk', {ret = 'int', 'int', 'int', 'float', 'pointer', 'float', 'pointer'})	

--	int gsl_blas_dsyrk (CBLAS_UPLO_t Uplo, CBLAS_TRANSPOSE_t Trans, double alpha, const gsl_matrix * A, double beta, gsl_matrix * C)
gsl.__register('gsl_blas_dsyrk', {ret = 'int', 'int', 'int', 'double', 'pointer', 'double', 'pointer'})	

--	int gsl_blas_csyrk (CBLAS_UPLO_t Uplo, CBLAS_TRANSPOSE_t Trans, const gsl_complex_float alpha, const gsl_matrix_complex_float * A, const gsl_complex_float beta, gsl_matrix_complex_float * C)
gsl.__register('gsl_blas_csyrk', {ret = 'int', 'int', 'int', 'int', 'pointer', 'int', 'pointer'})	

--	int gsl_blas_zsyrk (CBLAS_UPLO_t Uplo, CBLAS_TRANSPOSE_t Trans, const gsl_complex alpha, const gsl_matrix_complex * A, const gsl_complex beta, gsl_matrix_complex * C)
gsl.__register('gsl_blas_zsyrk', {ret = 'int', 'int', 'int', 'int', 'pointer', 'int', 'pointer'})	

--	int gsl_blas_cherk (CBLAS_UPLO_t Uplo, CBLAS_TRANSPOSE_t Trans, float alpha, const gsl_matrix_complex_float * A, float beta, gsl_matrix_complex_float * C)
gsl.__register('gsl_blas_cherk', {ret = 'int', 'int', 'int', 'float', 'pointer', 'float', 'pointer'})	

--	int gsl_blas_zherk (CBLAS_UPLO_t Uplo, CBLAS_TRANSPOSE_t Trans, double alpha, const gsl_matrix_complex * A, double beta, gsl_matrix_complex * C)
gsl.__register('gsl_blas_zherk', {ret = 'int', 'int', 'int', 'double', 'pointer', 'double', 'pointer'})	

--	int gsl_blas_ssyr2k (CBLAS_UPLO_t Uplo, CBLAS_TRANSPOSE_t Trans, float alpha, const gsl_matrix_float * A, const gsl_matrix_float * B, float beta, gsl_matrix_float * C)
gsl.__register('gsl_blas_ssyr2k', {ret = 'int', 'int', 'int', 'float', 'pointer', 'pointer', 'float', 'pointer'})	

--	int gsl_blas_dsyr2k (CBLAS_UPLO_t Uplo, CBLAS_TRANSPOSE_t Trans, double alpha, const gsl_matrix * A, const gsl_matrix * B, double beta, gsl_matrix * C)
gsl.__register('gsl_blas_dsyr2k', {ret = 'int', 'int', 'int', 'double', 'pointer', 'pointer', 'double', 'pointer'})	

--	int gsl_blas_csyr2k (CBLAS_UPLO_t Uplo, CBLAS_TRANSPOSE_t Trans, const gsl_complex_float alpha, const gsl_matrix_complex_float * A, const gsl_matrix_complex_float * B, const gsl_complex_float beta, gsl_matrix_complex_float * C)
gsl.__register('gsl_blas_csyr2k', {ret = 'int', 'int', 'int', 'int', 'pointer', 'pointer', 'int', 'pointer'})	

--	int gsl_blas_zsyr2k (CBLAS_UPLO_t Uplo, CBLAS_TRANSPOSE_t Trans, const gsl_complex alpha, const gsl_matrix_complex * A, const gsl_matrix_complex * B, const gsl_complex beta, gsl_matrix_complex * C)
gsl.__register('gsl_blas_zsyr2k', {ret = 'int', 'int', 'int', 'int', 'pointer', 'pointer', 'int', 'pointer'})	

--	int gsl_blas_cher2k (CBLAS_UPLO_t Uplo, CBLAS_TRANSPOSE_t Trans, const gsl_complex_float alpha, const gsl_matrix_complex_float * A, const gsl_matrix_complex_float * B, float beta, gsl_matrix_complex_float * C)
gsl.__register('gsl_blas_cher2k', {ret = 'int', 'int', 'int', 'int', 'pointer', 'pointer', 'float', 'pointer'})	

--	int gsl_blas_zher2k (CBLAS_UPLO_t Uplo, CBLAS_TRANSPOSE_t Trans, const gsl_complex alpha, const gsl_matrix_complex * A, const gsl_matrix_complex * B, double beta, gsl_matrix_complex * C)
gsl.__register('gsl_blas_zher2k', {ret = 'int', 'int', 'int', 'int', 'pointer', 'pointer', 'double', 'pointer'})	

-- INTERPOLATION
--	gsl_interp * gsl_interp_alloc (const gsl_interp_type * T, size_t size)
gsl.__register('gsl_interp_alloc', {ret = 'pointer', 'pointer', 'uint'})	

--	int gsl_interp_init (gsl_interp * interp, const double xa[], const double ya[], size_t size)
gsl.__register('gsl_interp_init', {ret = 'int', 'pointer', 'pointer', 'pointer', 'uint'})	

--	void gsl_interp_free (gsl_interp * interp)
gsl.__register('gsl_interp_free', {ret = 'int', 'pointer'})	

--	double gsl_interp_eval (const gsl_interp * interp, const double xa[], const double ya[], double x, gsl_interp_accel * acc)
gsl.__register('gsl_interp_eval', {ret = 'double', 'pointer', 'pointer', 'pointer', 'double', 'pointer'})	

--	int gsl_interp_eval_e (const gsl_interp * interp, const double xa[], const double ya[], double x, gsl_interp_accel * acc, double * y)
gsl.__register('gsl_interp_eval_e', {ret = 'int', 'pointer', 'pointer', 'pointer', 'double', 'pointer', 'ref double'})	

--	double gsl_interp_eval_deriv (const gsl_interp * interp, const double xa[], const double ya[], double x, gsl_interp_accel * acc)
gsl.__register('gsl_interp_eval_deriv', {ret = 'double', 'pointer', 'pointer', 'pointer', 'double', 'pointer'})	

--	int gsl_interp_eval_deriv_e (const gsl_interp * interp, const double xa[], const double ya[], double x, gsl_interp_accel * acc, double * d)
gsl.__register('gsl_interp_eval_deriv_e', {ret = 'int', 'pointer', 'pointer', 'pointer', 'double', 'pointer', 'ref double'})	

--	double gsl_interp_eval_deriv2 (const gsl_interp * interp, const double xa[], const double ya[], double x, gsl_interp_accel * acc)
gsl.__register('gsl_interp_eval_deriv2', {ret = 'double', 'pointer', 'pointer', 'pointer', 'double', 'pointer'})	

--	int gsl_interp_eval_deriv2_e (const gsl_interp * interp, const double xa[], const double ya[], double x, gsl_interp_accel * acc, double * d2)
gsl.__register('gsl_interp_eval_deriv2_e', {ret = 'int', 'pointer', 'pointer', 'pointer', 'double', 'pointer', 'ref double'})	

--	double gsl_interp_eval_integ (const gsl_interp * interp, const double xa[], const double ya[], double a, double b, gsl_interp_accel * acc)
gsl.__register('gsl_interp_eval_integ', {ret = 'double', 'pointer', 'pointer', 'pointer', 'double', 'double', 'pointer'})	

--	int gsl_interp_eval_integ_e (const gsl_interp * interp, const double xa[], const double ya[], double a, double b, gsl_interp_accel * acc, double * result)
gsl.__register('gsl_interp_eval_integ_e', {ret = 'int', 'pointer', 'pointer', 'pointer', 'double', 'double', 'pointer', 'ref double'})	

--	const char * gsl_interp_name (const gsl_interp * interp)
gsl.__register('gsl_interp_name', {ret = 'pointer', 'pointer'})	

--	unsigned int gsl_interp_min_size (const gsl_interp * interp)
gsl.__register('gsl_interp_min_size', {ret = 'int', 'pointer'})	

--	unsigned int gsl_interp_type_min_size (const gsl_interp_type * T)
gsl.__register('gsl_interp_type_min_size', {ret = 'int', 'pointer'})	

--	int gsl_fit_linear (const double * x, const size_t xstride, const double * y, const size_t ystride, size_t n, double * c0, double * c1, double * cov00, double * cov01, double * cov11, double * sumsq)
gsl.__register('gsl_fit_linear', {ret = 'int', 'pointer', 'uint', 'pointer', 'uint', 'uint', 'ref double', 'ref double', 'ref double', 'ref double', 'ref double', 'ref double'})	

--	int gsl_fit_wlinear (const double * x, const size_t xstride, const double * w, const size_t wstride, const double * y, const size_t ystride, size_t n, double * c0, double * c1, double * cov00, double * cov01, double * cov11, double * chisq)
gsl.__register('gsl_fit_wlinear', {ret = 'int', 'pointer', 'uint', 'pointer', 'uint', 'pointer', 'uint', 'uint', 'ref double', 'ref double', 'ref double', 'ref double', 'ref double', 'ref double'})	

--	int gsl_fit_linear_est (double x, double c0, double c1, double cov00, double cov01, double cov11, double * y, double * y_err)
gsl.__register('gsl_fit_linear_est', {ret = 'int', 'double', 'double', 'double', 'double', 'double', 'double', 'ref double', 'ref double'})	

--	gsl_multifit_linear_workspace * gsl_multifit_linear_alloc (size_t n, size_t p)
gsl.__register('gsl_multifit_linear_alloc', {ret = 'pointer', 'uint', 'uint'})	

--	void gsl_multifit_linear_free (gsl_multifit_linear_workspace * work)
gsl.__register('gsl_multifit_linear_free', {ret = 'int', 'pointer'})	

--	int gsl_multifit_linear (const gsl_matrix * X, const gsl_vector * y, gsl_vector * c, gsl_matrix * cov, double * chisq, gsl_multifit_linear_workspace * work)
gsl.__register('gsl_multifit_linear', {ret = 'int', 'pointer', 'pointer', 'pointer', 'pointer', 'ref double', 'pointer'})	

--	int gsl_multifit_wlinear (const gsl_matrix * X, const gsl_vector * w, const gsl_vector * y, gsl_vector * c, gsl_matrix * cov, double * chisq, gsl_multifit_linear_workspace * work)
gsl.__register('gsl_multifit_wlinear', {ret = 'int', 'pointer', 'pointer', 'pointer', 'pointer', 'pointer', 'ref double', 'pointer'})	

--	int gsl_multifit_linear_svd (const gsl_matrix * X, const gsl_vector * y, double tol, size_t * rank, gsl_vector * c, gsl_matrix * cov, double * chisq, gsl_multifit_linear_workspace * work)
gsl.__register('gsl_multifit_linear_svd', {ret = 'int', 'pointer', 'pointer', 'double', 'ref uint', 'pointer', 'pointer', 'ref double', 'pointer'})	

--	int gsl_multifit_wlinear_svd (const gsl_matrix * X, const gsl_vector * w, const gsl_vector * y, double tol, size_t * rank, gsl_vector * c, gsl_matrix * cov, double * chisq, gsl_multifit_linear_workspace * work)
gsl.__register('gsl_multifit_wlinear_svd', {ret = 'int', 'pointer', 'pointer', 'pointer', 'double', 'ref uint', 'pointer', 'pointer', 'ref double', 'pointer'})	

--	int gsl_multifit_linear_usvd (const gsl_matrix * X, const gsl_vector * y, double tol, size_t * rank, gsl_vector * c, gsl_matrix * cov, double * chisq, gsl_multifit_linear_workspace * work)
gsl.__register('gsl_multifit_linear_usvd', {ret = 'int', 'pointer', 'pointer', 'double', 'ref uint', 'pointer', 'pointer', 'ref double', 'pointer'})	

--	int gsl_multifit_wlinear_usvd (const gsl_matrix * X, const gsl_vector * w, const gsl_vector * y, double tol, size_t * rank, gsl_vector * c, gsl_matrix * cov, double * chisq, gsl_multifit_linear_workspace * work)
gsl.__register('gsl_multifit_wlinear_usvd', {ret = 'int', 'pointer', 'pointer', 'pointer', 'double', 'ref uint', 'pointer', 'pointer', 'ref double', 'pointer'})	

--	int gsl_multifit_linear_est (const gsl_vector * x, const gsl_vector * c, const gsl_matrix * cov, double * y, double * y_err)
gsl.__register('gsl_multifit_linear_est', {ret = 'int', 'pointer', 'pointer', 'pointer', 'ref double', 'ref double'})	

--	int gsl_multifit_linear_residuals (const gsl_matrix * X, const gsl_vector * y, const gsl_vector * c, gsl_vector * r)
gsl.__register('gsl_multifit_linear_residuals', {ret = 'int', 'pointer', 'pointer', 'pointer', 'pointer'})	

