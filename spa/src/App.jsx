import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend,
} from 'chart.js'

// Components
import Header from './components/Header/Header'
import RefreshButton from './components/RefreshButton/RefreshButton'
import ErrorMessage from './components/ErrorMessage/ErrorMessage'
import LoadingSpinner from './components/LoadingSpinner/LoadingSpinner'
import ProductChart from './components/ProductChart/ProductChart'
import ProductGrid from './components/ProductGrid/ProductGrid'

import { useProducts } from './hooks/useProducts'

ChartJS.register(
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend
)

function App() {
  const { products, loading, error, refreshProducts } = useProducts()

  return (
    <div className="app">
      <Header />
      
      <main className="app-main">
        <RefreshButton 
          onRefresh={refreshProducts} 
          loading={loading} 
        />

        <ErrorMessage error={error} />

        {loading && products.length === 0 && <LoadingSpinner />}

        <ProductChart products={products} />
        
        <ProductGrid products={products} />
      </main>
    </div>
  )
}

export default App 