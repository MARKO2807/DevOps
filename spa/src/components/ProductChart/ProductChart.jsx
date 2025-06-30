import { Bar } from 'react-chartjs-2'
import { chartColors, chartOptions } from '../../utils/chartConfig'
import './ProductChart.css'

function ProductChart({ products }) {
  if (!products || products.length === 0) return null

  const chartData = {
    labels: products.map(product => product.title.length > 15 
      ? product.title.substring(0, 15) + '...' 
      : product.title
    ),
    datasets: [
      {
        label: 'Price ($)',
        data: products.map(product => product.price),
        backgroundColor: chartColors.background,
        borderColor: chartColors.border,
        borderWidth: 1,
      },
    ],
  }

  return (
    <div className="chart-container">
      <Bar data={chartData} options={chartOptions} />
    </div>
  )
}

export default ProductChart 